//= require browser_utils
//= require array_utils
//= require hammer.min
//= require hammer-setup
//= require jquery.hammer.min
//= require ./analysis_matrices/analysis_matrix/expression_recognizer
//= require ./analysis_matrices/analysis_matrix/expression_input_name
//= require ./analysis_matrices/analysis_matrix/criticality
//= require_tree ./analysis_matrices/
//= require jquery.ui.dialog
//= require errors_dialog
//= require jquery.ui.autocomplete
//= require suggestions_autocomplete
//= require tap_conflict_free
//= require on_hold
//= require show_dialog_button
//= require_tree ./ajax/

var matrix;
$(function(){
  var AnalysisMatrixStarter = LNX_INCIDENT_PLANNING.AnalysisMatrix.AnalysisMatrixStarter;
  matrix = new AnalysisMatrixStarter().start($(".analysis-matrix"));

  $(".btn-show-dialog").asShowDialogButton();
  $(".approvable-triangle").each(function() {
    var $triangleDiv = $(this);
    var $td = $triangleDiv.closest("td");
    var position = $td.offset()
    position.top += 2;
    position.left += 2;
    $triangleDiv.offset(position);
  });
});
