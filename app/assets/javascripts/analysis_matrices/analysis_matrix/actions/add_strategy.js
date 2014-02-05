(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;

  Actions.AddStrategy = function(cell, $father) {
    this.$father = $father;
    this.cell = cell;
  };

  var _func = Actions.AddStrategy;
  _func.bindIn = function(matrix, cell, $father) {
    cell.$element.on("click", $father, function(event) {
      event.preventDefault();

      var template = Templates.NewStrategy.renderIn(matrix, cell);
      bindFormEventsOn(template);
    });

    return new Actions.AddStrategy(cell, $father);
  };

  function bindFormEventsOn(template) {
    template.$submitTd.find("button").on("click", function(event) {
      event.preventDefault();
      var $form = $("<form>");
      $form.append(template.$inputsTds);

      var params = $form.serialize();
      params["authenticity_token"] = $("meta[name='csrf-token']").attr("content");

      $.post(document.location.href, params, function() {
        document.location.reload();
      });
    });
  }

}(jQuery, LNX_INCIDENT_PLANNING));
