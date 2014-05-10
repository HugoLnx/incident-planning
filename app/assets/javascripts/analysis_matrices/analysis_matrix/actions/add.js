(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var Ajax = LNX_UTILS.Ajax;
  var ExpressionRecognizer = namespace.AnalysisMatrix.ExpressionRecognizer;

  Actions.Add = function(targetsSelector, template, backendProtocol) {
    this.targetsSelector = targetsSelector;
    this.template = template;
    this.backendProtocol = backendProtocol;
  };

  var _function = Actions.Add;
  _function.strategyAction = function() {
    return new Actions.Add(
      ".strategy.add",
      Templates.FormTemplate.newStrategy(),
      BackendProtocols.Add.strategyProtocol()
    );
  };

  _function.tacticAction = function() {
    return new Actions.Add(
      ".tactic.add",
      Templates.FormTemplate.newTactic(),
      BackendProtocols.Add.tacticProtocol()
    );
  };

  var _prototype = Actions.Add.prototype;
  _prototype.bindIn = function(matrix, $father) {
    var self = this;
    $father.on("click", this.targetsSelector, function(event) {
      event.preventDefault();
      
      var $td = $(this);
      var cell = matrix.findCells($td)[0];

      var form = self.template.evaluate();
      var renderer = new Templates.FormRenderer(matrix);

      bindOnExpressionSuggestion(form);
      bindOnSubmit(form, self.backendProtocol, $td);

      renderer.render(form, {replacing: [cell]});
    });
  };

  // TODO: ESSE TRECHO DE CÓDIGO ESTÁ REPETIDO NO app/assets/javascripts/analysis_matrices/analysis_matrix/actions/update.js
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

  function bindOnSubmit(form, backendProtocol, $td) {
    form.$submit().on("click", function() {
      var ajax = new Ajax.AjaxRequestBuilder();
      ajax.addParamsFromInputs(form.$inputs());

      ajax.addParams(backendProtocol.params($td));

      $.ajax({
        url: backendProtocol.path(),
        data: ajax.paramsToUrl(),
        method: backendProtocol.httpMethodForBrowser(),
        success: function(){document.location.reload();}
      });
    });
  }
}(jQuery, LNX_INCIDENT_PLANNING));
