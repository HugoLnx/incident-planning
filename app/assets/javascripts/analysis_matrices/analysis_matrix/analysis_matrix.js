(function($, context) {

  var Matrix = context.Matrix;
  var AnalysisMatrix = context.AnalysisMatrix;

  AnalysisMatrix.AnalysisMatrix = function(matrix) {
    this.matrix = matrix;
  };



  var prototype = AnalysisMatrix.AnalysisMatrix.prototype;

  prototype.newRow = function(rowNumber) {
    var $tr = Matrix.Row.newElement();
    var newRow = this.matrix.insertRow($tr, rowNumber);

    newRow.pushCell(Matrix.Cell.newElement());
    newRow.pushCell(Matrix.Cell.newElement());
    newRow.pushCell(Matrix.Cell.newElement());
    newRow.pushCell(Matrix.Cell.newElement());
    newRow.pushCell(Matrix.Cell.newElement());
    newRow.pushCell(Matrix.Cell.newElement());
    newRow.pushCell(Matrix.Cell.newElement());
    newRow.pushCell(Matrix.Cell.newElement());

    return newRow;
  };

}(jQuery, LNX_INCIDENT_PLANNING));
