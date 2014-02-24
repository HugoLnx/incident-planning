(function($, namespace, utils) {
  var Matrix = namespace.Matrix;

  Matrix.Cell = function($element, row) {
    this.$element = $element;
    this.row = row;
  }



  var func = Matrix.Cell;

  func.newElement = function() {
    return $("<td>");
  };

  func.buildAll = function($tds) {
    var cells = $tds.map(function() {
      return new Matrix.Cell($(this));
    });
    return cells;
  };

  func.replaceWith = function(cells, newCells) {
    var $newTds = $.map(newCells, function(cell){
      return cell.$element[0];
    });

    var $oldTds =  $.map(cells, function(cell){
      return cell.$element[0];
    });

    var lastOldTds = $oldTds.splice(0, $oldTds.length-1);
    $(lastOldTds).remove()
    var $firstOldTd = $($oldTds);

    $firstOldTd.replaceWith($newTds);

    var row = cells[0].row;
    var firstCellInx = row.cells.indexOf(cells[0]);
    utils.ArrayUtils.splice(row.cells, firstCellInx, cells.length, newCells);
  };

  func.extractData = function(cells) {
    var data = {};
    for(var i = 0; i<cells.length; i++) {
      var cell = cells[i];
      var text = cell.$element.text();
      if (text !== "") {
        data[cell.expressionName()] = text;
      }
    }
    return data;
  };


  var prototype = Matrix.Cell.prototype;

  prototype.replaceWith = function(cells) {
    Matrix.Cell.replaceWith([this], cells);
  };

  prototype.expressionName = function() {
    var EXPRESSION_NAMES = ["objective", "how", "why", "who", "what", "where", "when", "response-action"];
    for(var i = 0; i<EXPRESSION_NAMES.length; i++) {
      var name = EXPRESSION_NAMES[i];
      if (this.$element.hasClass(name)) {
        return name;
      }
    }
  };
}(jQuery, LNX_INCIDENT_PLANNING, LNX_UTILS));
