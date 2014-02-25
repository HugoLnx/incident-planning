//= require_tree ./analysis_matrices/
//= require array_utils
//= require_tree ./ajax/

var matrix;
$(function(){
  var AnalysisMatrixStarter = LNX_INCIDENT_PLANNING.AnalysisMatrix.AnalysisMatrixStarter;
  matrix = new AnalysisMatrixStarter().start($(".analysis-matrix"));
});
