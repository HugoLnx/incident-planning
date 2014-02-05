(function($, namespace) {
  var Matrix = namespace.Matrix;

  Matrix.Matrix = function($table, $data_trs) {
    this.rows = [];
    this.$table = $table;
    var matrix = this;

    $data_trs.each(function() {
      var $tr = $(this);
      var row = Matrix.Row.buildWithCells($tr);
      matrix.rows.push(row);
    });
  };



  var _prototype = Matrix.Matrix.prototype;

  _prototype.insertRow = function($newTr, rowNumber) {
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

  _prototype.findRows = function($trs) {
    var rows = $(this.rows).filter(function() {
      return isWrapperOneOfElements(this, $trs)
    });

    return rows;
  };

  _prototype.findCells = function($tds) {
    var allCells = this.allCells();
    var cells = $(allCells).filter(function() {
      return isWrapperOneOfElements(this, $tds);
    });

    return cells;
  };

  _prototype.allCells = function() {
    var cells = [];

    $(this.rows).each(function() {
      var row = this;
      Array.prototype.push.apply(cells, row.cells);
    });

    return cells
  };

  function isWrapperOneOfElements(wrapper, $elements) {
    for(var i = 0; i<$elements.length; i++) {
      if (wrapper.$element[0] === $elements[i]) {
        return true;
      };
    }
    return false;
  }

}(jQuery, LNX_INCIDENT_PLANNING));
