(function($, context) {
  var Matrix = context.Matrix;

  Matrix.Matrix = function($table, $data_trs) {
    this.rows = [];
    this.$table = $table;
    var matrix = this;

    $data_trs.each(function() {
      var $tr = $(this);
      var row = Matrix.Row.buildWithCells($tr);
      matrix.rows.push(row);
    });
  }



  var prototype = Matrix.Matrix.prototype;

  prototype.insertRow = function($newTr, rowNumber) {
    var row = this.rows[rowNumber];
    var newRow = new Matrix.Row($newTr);

    if (row) {
      row.$element.before($newTr);
    } else {
      this.$table.append($newTr);
    }
    this.rows.splice(rowNumber, 0, newRow);
    return newRow;
  };

}(jQuery, LNX_INCIDENT_PLANNING));
