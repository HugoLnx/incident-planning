//= require_tree ./analysis_matrices/
//= require dialog/jquery-ui-1.10.4.dialog.min
//= require array_utils
//= require_tree ./ajax/

var matrix;
$(function(){
  var AnalysisMatrixStarter = LNX_INCIDENT_PLANNING.AnalysisMatrix.AnalysisMatrixStarter;
  matrix = new AnalysisMatrixStarter().start($(".analysis-matrix"));
});
