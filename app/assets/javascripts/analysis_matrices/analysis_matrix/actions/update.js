(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var Ajax = LNX_UTILS.Ajax;
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

      var reusedExpressionIds = extractReusedIdsFrom($tds);
      var expressionIds = extractExpressionIdsFrom($tds);

      var initialData = self.updateProtocol.currentData(cells);
      var form = self.template.evaluate(initialData);
      var renderer = new Templates.FormRenderer(matrix);

      changeReusedExpressionsIn(form, reusedExpressionIds);

      bindOnExpressionSuggestion(form, expressionIds);
      bindOnSubmit(form, self.updateProtocol, $td);
      bindOnDeleteBtn(form.$deleteBtn(), self.deleteProtocol, $td);

      renderer.render(form, {replacing: cells});
    }
    $father.on("dblclick", this.targetsSelector, openForm);
    $father.hammer().on("doubletap", this.targetsSelector, openForm);
  };

  function changeReusedExpressionsIn(form, reusedExpressionIds) {
    form.$inputsTds().find("input").each(function() {
      var $input = $(this);
      var text = $input.val();

      var expressionName = ExpressionRecognizer.getPrettyNameFromInput($input);
      var reusedExpressionId = reusedExpressionIds[expressionName];

      if (reusedExpressionId !== "" && reusedExpressionId !== undefined) {
        Reuse.InputRenderer.becameReused($input, text, reusedExpressionId);
      }
    });
  }

  function extractReusedIdsFrom($tds) {
    var ids = {};
    $tds.each(function() {
      var $td = $(this);
      var expressionName = ExpressionRecognizer.getPrettyNameFromTd($td);
      ids[expressionName] = $td.data("reused-expression-id");
    });
    return ids;
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

      $input.autocomplete({
        source: source,
        change: function(event, ui) {
          var userHasSelectedAnItem = ui.item !== null;
          if (!userHasSelectedAnItem) {
            Reuse.InputRenderer.becameNonReused($input);
          }
        },
        select: function(event, ui) {
          event.preventDefault();
          var item = ui.item;
          Reuse.InputRenderer.becameReused($input, item.label, item.value);
        }
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
