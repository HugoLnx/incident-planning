//= require_tree ./analysis_matrices/
//= require array_utils

var matrix;
$(function(){
  var Matrix = LNX_INCIDENT_PLANNING.Matrix.Matrix;
  var AnalysisMatrix = LNX_INCIDENT_PLANNING.AnalysisMatrix.AnalysisMatrix;
  matrix = AnalysisMatrix.buildFromTable($(".analysis-matrix"));
});
