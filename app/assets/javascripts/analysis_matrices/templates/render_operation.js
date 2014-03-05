(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;
  var Model = namespace.Model;

  Templates.RenderOperation = function(matrix, opts) {
    var opts = opts || {};
    this.matrix = matrix;
    if (opts.newRow) {
      this.$newRowElement = opts.newRow.$element;
      this.newRowNumber = opts.newRow.number;
    }
    if (opts.cells) {
      this.oldCells = opts.cells.olds;
      this.newCells = opts.cells.news;
    }
  };

  var _prototype = Templates.RenderOperation.prototype;

  _prototype.execute = function() {
    var row = this.matrix.insertRow(this.$newRowElement, this.newRowNumber);
    Matrix.Cell.replaceWith(this.oldCells, this.newCells);
  };

  _prototype.back = function() {
    this.matrix.removeRow(this.newRowNumber);
    Matrix.Cell.replaceWith(this.newCells, this.oldCells);
  };

} (jQuery, LNX_INCIDENT_PLANNING));
