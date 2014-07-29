//= require hammer.min
//= require hammer-setup
//= require jquery.hammer.min
//= require ./analysis_matrices/analysis_matrix/expression_recognizer
//= require_tree ./analysis_matrices/
//= require jquery.ui.dialog
//= require tap_conflict_free
//= require array_utils
//= require show_dialog_button
//= require analysis_matrix_published_starter

var matrix;
$(function(){
  var AnalysisMatrixPublishedStarter = LNX_INCIDENT_PLANNING.AnalysisMatrix.AnalysisMatrixPublishedStarter;
  matrix = new AnalysisMatrixPublishedStarter().start($(".analysis-matrix"));

  $(".btn-show-dialog").asShowDialogButton();
});
