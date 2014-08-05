(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var Ajax = LNX_UTILS.Ajax;
  var BrowserUtils = LNX_UTILS.BrowserUtils;
  var ExpressionRecognizer = namespace.AnalysisMatrix.ExpressionRecognizer;
  var Reuse = namespace.AnalysisMatrix.Reuse;
  var FROM_RAILS = namespace.FROM_RAILS;

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
    function openForm(event) {
      event.preventDefault();

      $(".cancel-btn").click();

      var $td = $(this);
      var $tds = $td.add($(this).siblings(self.siblingsSelector));
      var cells = matrix.findCells($tds);

      var expressionIds = extractExpressionIdsFrom($tds);

      var initialData = self.updateProtocol.currentData(cells);
      var form = self.template.evaluate(initialData);
      var renderer = new Templates.FormRenderer(matrix);

      changeReusedExpressionsIn(form, $tds);

      bindOnExpressionSuggestion(form, expressionIds);
      bindOnSubmit(form, self.updateProtocol, $td);
      bindOnDeleteBtn(form.$deleteBtn(), self.deleteProtocol, $td);

      renderer.render(form, {replacing: cells});
    }
    //$father.on("dblclick", this.targetsSelector, openForm);
    $father.hammer().on("doubletap", this.targetsSelector, openForm);
  };

  function changeReusedExpressionsIn(form, $cellsTds) {
    var $inputsTds = form.$inputsTds();
    
    $cellsTds.each(function() {
      var $cellTd = $(this);

      var expressionName = ExpressionRecognizer.getNameFromTd($cellTd);
      var $input = $inputsTds.find("input[name$=" + expressionName + "\\]]");
      var text = $input.val();

      if ($cellTd.hasClass("reused")) {
        Reuse.InputRenderer.becameReused($input, text, null);
      }
    });
  }

  function extractExpressionIdsFrom($tds) {
    var ids = {};
    $tds.each(function() {
      var $td = $(this);
      var expressionName = ExpressionRecognizer.getPrettyNameFromTd($td);
      ids[expressionName] = $td.data("expression-id");
    });
    return ids;
  }

  // TODO: ESSE TRECHO DE CÓDIGO ESTÁ REPETIDO NO app/assets/javascripts/analysis_matrices/analysis_matrix/actions/add.js
  function bindOnExpressionSuggestion(form, expressionIds) {
    form.$inputsTds().find("input").each(function() {
      var $input = $(this);

      var expressionName = ExpressionRecognizer.getPrettyNameFromInput($input);
      var expressionId = expressionIds[expressionName];
      var source = "/incident/" + FROM_RAILS.current_incident_id +
        "/expression_suggestions/" + expressionName +
      "?expression_updated_id=" + expressionId;

      $input.suggestionsAutocomplete({
        source: source
      });
    });
  }

  function bindOnSubmit(form, updateProtocol, $td) {
    form.$submit().on("click", function() {
      var request = new Ajax.AjaxRequestBuilder();
      request.addParamsFromInputs(form.$inputs());

      sendAjaxUsing(request, updateProtocol, $td, function(result) {
        if (result === "success") {
          BrowserUtils.reloadPage();
        } else {
          $(result).errorsDialog({
            position: {
              my: "top",
              at: "bottom",
              of: form.$submitRow()
            },
          });
        };
      });
    });
  }

  function bindOnDeleteBtn($deleteBtn, deleteProtocol, $td) {
    $deleteBtn.on("click", function() {
      var request = new Ajax.AjaxRequestBuilder();

      sendAjaxUsing(request, deleteProtocol, $td, function() {
        BrowserUtils.reloadPage();
      });
    });
  }

  function sendAjaxUsing(request, backendProtocol, $td, onSuccess) {
    request.addParams(backendProtocol.params());

    $.ajax({
      url: backendProtocol.path($td),
      data: request.paramsToUrl(),
      method: backendProtocol.httpMethodForBrowser(),
        success: onSuccess
    });
  }
}(jQuery, LNX_INCIDENT_PLANNING));
