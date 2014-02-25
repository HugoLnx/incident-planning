(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;

  Actions.UpdateStrategy = function(cells, $father) {
    this.$father = $father;
    this.cells = cells;
  };

  var _func = Actions.UpdateStrategy;
  _func.bindIn = function(matrix, $td, cells, $father) {
    $td.on("dblclick", $father, function(event) {
      event.preventDefault();

      var currentData = Matrix.Cell.extractData(cells);

      var template = Templates.NewStrategy.renderIn(matrix, cells, {
        defaultData: currentData,
        submitButton: "Update"
      });

      var updatePath = $(this).data("update_path");
      bindFormEventsOn(template, updatePath);
    });

    return new Actions.UpdateStrategy(cells, $father);
  };

  function bindFormEventsOn(template, updatePath) {
    template.$submitTd.find("button").on("click", function(event) {
      event.preventDefault();
      var $form = $("<form>");
      $form.append(template.$inputsTds);

      var authenticityToken = $("meta[name='csrf-token']").attr("content")
      $form.append($("<input type='hidden'>").attr("name", "authenticity_token").val(authenticityToken))
      $form.append($("<input type='hidden'>").attr("name", "_method").val("put"))

      var params = $form.serialize();
      $.post(updatePath, params, function() {
        document.location.reload();
      });
    });
  }

}(jQuery, LNX_INCIDENT_PLANNING));
