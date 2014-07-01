//= require hammer.min
//= require jquery.hammer.min
//= require_tree ./analysis_matrices/
//= require jquery.ui.dialog
//= require tap_conflict_free
//= require array_utils
//= require show_dialog_button
//= require_tree ./ajax/

(function($, namespace) {
  var Actions = namespace.AnalysisMatrix.Actions;

  $(function() {
    var $table = $(".analysis-matrix");
    Actions.ShowMetadata.defaultAction().bindIn($table, "Objective");
    Actions.ShowMetadata.defaultAction().bindIn($table, "Strategy");
    Actions.ShowMetadata.defaultAction().bindIn($table, "Tactic");
  });
}(jQuery, LNX_INCIDENT_PLANNING));
