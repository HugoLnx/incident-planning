(function($, namespace) {

  var Matrix = namespace.Matrix;
  var AnalysisMatrix = namespace.AnalysisMatrix;

  AnalysisMatrix.AnalysisMatrix = function(matrix) {
    this.matrix = matrix;
  };

  var _func = AnalysisMatrix.AnalysisMatrix;

  _func.COLS = 8;

  _func.buildFromTable = function($table) {
    var $trs = $table.find("tr").slice(2);
    return new AnalysisMatrix.AnalysisMatrix(new Matrix.Matrix($table, $trs));
  };



  var _prototype = AnalysisMatrix.AnalysisMatrix.prototype;

  _prototype.newRow = function(rowNumber) {
    var $tr = Matrix.Row.newElement();
    var newRow = this.matrix.insertRow($tr, rowNumber);

    for(var i = 1; i <= _func.COLS; i++) {
      newRow.pushCell(Matrix.Cell.newElement());
    }

    return newRow;
  };

}(jQuery, LNX_INCIDENT_PLANNING));
