(function($, namespace, utils) {
  var Actions = namespace.AnalysisMatrix.Actions;
  var TapConflictFree = utils.TapConflictFree;

  var obj = Actions.UpdateObjective;
  obj.bindIn = function($father) {
    var $warning = $("#objective-cant-edit-warning");
    $father.hammer().on("doubletap", ".objective.non-repeated", displayObjectiveWarning);

    function displayObjectiveWarning(event) {
      event.preventDefault();

      $warning.clone().dialog({
        title: "Objective",
        hide: true,
        closeText: "",
        position: {
          my: "left top",
          at: "left bottom",
          of: this
        },
        close: function() {
          $(this).remove();
        }
      });
    }
  };
}(jQuery, LNX_INCIDENT_PLANNING, LNX_UTILS));
