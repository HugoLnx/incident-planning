//= require_tree ./analysis_matrices/

var matrix;
$(function(){
  var Matrix = LNX_INCIDENT_PLANNING.Matrix.Matrix;
  var AnalysisMatrix = LNX_INCIDENT_PLANNING.AnalysisMatrix.AnalysisMatrix;
  matrix = AnalysisMatrix.buildFromTable($(".analysis-matrix"));
});
