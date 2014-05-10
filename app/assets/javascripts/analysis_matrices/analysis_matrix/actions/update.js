(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var Ajax = LNX_UTILS.Ajax;
  var ExpressionRecognizer = namespace.AnalysisMatrix.ExpressionRecognizer;

  Actions.Update = function(targetsSelector, siblingsSelector, template) {
    this.targetsSelector = targetsSelector;
    this.siblingsSelector = siblingsSelector;
    this.template = template;
    this.updateProtocol = BackendProtocols.Update.defaultProtocol();
    this.deleteProtocol = BackendProtocols.Delete.defaultProtocol();
  };

  var _function = Actions.Update;
  _function.strategyAction = function() {
    return new Actions.Update(
      ".strategy.editable",
      ".strategy",
      new Templates.FormTemplate.editStrategy()
    );
  };

  _function.tacticAction = function() {
    return new Actions.Update(
      ".tactic.editable",
      ".tactic",
      new Templates.FormTemplate.editTactic()
    );
  };

  var _prototype = Actions.Update.prototype;
  _prototype.bindIn = function(matrix, $father) {
    var self = this;
    $father.on("dblclick", this.targetsSelector, function(event) {
      event.preventDefault();

      var $td = $(this);
      var $tds = $td.add($(this).siblings(self.siblingsSelector));
      var cells = matrix.findCells($tds);

      var initialData = self.updateProtocol.currentData(cells);
      var form = self.template.evaluate(initialData);
      var renderer = new Templates.FormRenderer(matrix);

      bindOnExpressionSuggestion(form);
      bindOnSubmit(form, self.updateProtocol, $td);
      bindOnDeleteBtn(form.$deleteBtn(), self.deleteProtocol, $td);

      renderer.render(form, {replacing: cells});
    });
  };

  function bindOnExpressionSuggestion(form) {
    form.$inputsTds().find("input").each(function() {
      var $input = $(this);

      var expressionName = ExpressionRecognizer.getPrettyNameFromInput($input);
      var source = "/expression_suggestions/" + expressionName;

      $input.autocomplete({
        source: source
      });
    });
  }

  function bindOnSubmit(form, updateProtocol, $td) {
    form.$submit().on("click", function() {
      var request = new Ajax.AjaxRequestBuilder();
      request.addParamsFromInputs(form.$inputs());

      sendAjaxUsing(request, updateProtocol, $td);
    });
  }

  function bindOnDeleteBtn($deleteBtn, deleteProtocol, $td) {
    $deleteBtn.on("click", function() {
      var request = new Ajax.AjaxRequestBuilder();

      sendAjaxUsing(request, deleteProtocol, $td);
    });
  }

  function sendAjaxUsing(request, backendProtocol, $td) {
    request.addParams(backendProtocol.params());

    $.ajax({
      url: backendProtocol.path($td),
      data: request.paramsToUrl(),
      method: backendProtocol.httpMethodForBrowser(),
      success: function(){document.location.reload();}
    });
  }
}(jQuery, LNX_INCIDENT_PLANNING));
