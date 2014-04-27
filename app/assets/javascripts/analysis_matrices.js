//= require_tree ./analysis_matrices/
//= require jquery.ui.dialog
//= require array_utils
//= require on_hold
//= require show_dialog_button
//= require_tree ./ajax/

var matrix;
$(function(){
  var AnalysisMatrixStarter = LNX_INCIDENT_PLANNING.AnalysisMatrix.AnalysisMatrixStarter;
  matrix = new AnalysisMatrixStarter().start($(".analysis-matrix"));

  $(".btn-show-dialog").asShowDialogButton();
});
