(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var Ajax = LNX_UTILS.Ajax;

  Actions.Update = function(targetsSelector, siblingsSelector, template, backendProtocol) {
    this.targetsSelector = targetsSelector;
    this.siblingsSelector = siblingsSelector;
    this.template = template;
    this.backendProtocol = backendProtocol;
  };

  var _function = Actions.Update;
  _function.strategyAction = function() {
    return new Actions.Update(
      ".strategy.show.non-repeated",
      ".strategy",
      new Templates.NewStrategy(),
      BackendProtocols.Update.defaultProtocol()
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
        defaultData: self.backendProtocol.currentData(cells),
        submitButton: "Update"
      });

      bindOnSubmit(form, self.backendProtocol, $td);
    });
  };

  function bindOnSubmit(form, backendProtocol, $td) {
    form.$submit().on("click", function() {
      var ajax = new Ajax.AjaxRequestBuilder();
      ajax.addParamsFromInputs(form.$inputs());

      ajax.addParams(backendProtocol.params());

      $.ajax({
        url: backendProtocol.path($td),
        data: ajax.paramsToUrl(),
        method: backendProtocol.httpMethodForBrowser(),
        success: function(){document.location.reload();}
      });
    });
  }
}(jQuery, LNX_INCIDENT_PLANNING));
