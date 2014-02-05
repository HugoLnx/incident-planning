(function($, namespace) {
  var Matrix = namespace.Matrix;

  Matrix.Row = function($element, cells) {
    this.$element = $element;
    this.cells = cells || [];
  }



  var func = Matrix.Row;

  func.buildWithCells = function($tr) {
    var row = new Matrix.Row($tr);
    $tr.find("td").each(function() {
      var $td = $(this);
      var cell = new Matrix.Cell($td);
      row.cells.push(cell);
    });
    return row;
  };

  func.newElement = function($tr) {
    return $("<tr>");
  }



  var prototype = Matrix.Row.prototype;

  prototype.pushCell = function($td) {
    this.$element.append($td);
    var newCell = new Matrix.Cell($td, this);
    this.cells.push(newCell);

    return newCell;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
