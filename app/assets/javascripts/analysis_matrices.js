//= require_tree ./analysis_matrices/

var matrix;
$(function(){
  var Matrix = LNX_INCIDENT_PLANNING.Matrix.Matrix;
  var AnalysisMatrix = LNX_INCIDENT_PLANNING.AnalysisMatrix.AnalysisMatrix;
  var $table = $(".analysis-matrix");
  var $trs = $table.find("tr").slice(2);
  matrix = new AnalysisMatrix(new Matrix($table, $trs));
});
