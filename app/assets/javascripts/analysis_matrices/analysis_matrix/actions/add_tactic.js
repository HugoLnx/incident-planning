(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;

  Actions.AddTactic = function(cell, $father) {
    this.$father = $father;
    this.cell = cell;
  };

  var _func = Actions.AddTactic;
  _func.bindIn = function(matrix, cell, $father) {
    cell.$element.on("click", $father, function(event) {
      event.preventDefault();

      var template = Templates.NewTactic.renderIn(matrix, cell);

      var fatherId = $(this).data("father_id");
      //bindFormEventsOn(template, fatherId);
    });

    return new Actions.AddStrategy(cell, $father);
  };

  //function bindFormEventsOn(template, fatherId) {
  //  template.$submitTd.find("button").on("click", function(event) {
  //    event.preventDefault();
  //    var $form = $("<form>");
  //    $form.append(template.$inputsTds);

  //    var authenticityToken = $("meta[name='csrf-token']").attr("content")
  //    $form.append($("<input type='hidden'>").attr("name", "authenticity_token").val(authenticityToken))
  //    $form.append($("<input type='hidden'>").attr("name", "strategy[father_id]").val(fatherId))

  //    var params = $form.serialize();
  //    $.post(document.location.href, params, function() {
  //      document.location.reload();
  //    });
  //  });
  //}

}(jQuery, LNX_INCIDENT_PLANNING));
