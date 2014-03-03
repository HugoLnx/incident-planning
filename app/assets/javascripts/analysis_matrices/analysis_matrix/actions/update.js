(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var Ajax = LNX_UTILS.Ajax;

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
      ".strategy.show.non-repeated",
      ".strategy",
      new Templates.NewStrategy()
    );
  };

  _function.tacticAction = function() {
    return new Actions.Update(
      ".tactic.show.non-repeated",
      ".tactic",
      new Templates.NewTactic()
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

      var form = self.template.renderIn(matrix, cells, {
        defaultData: self.updateProtocol.currentData(cells),
        submitButton: "Update",
        withDelete: true
      });

      bindOnSubmit(form, self.updateProtocol, $td);
      bindOnDeleteBtn(form.$deleteBtn(), self.deleteProtocol, $td);
    });
  };

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
