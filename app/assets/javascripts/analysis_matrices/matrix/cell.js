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



  var prototype = Matrix.Cell.prototype;

  prototype.replaceWith = function(cells) {
    var $tds = $.map(cells, function(cell){
      return cell.$element;
    });

    var $tdAfter = this.$element.next();
    this.$element.remove();
    $tdAfter.before($tds);

    var cellInx = this.row.cells.indexOf(this);
    utils.ArrayUtils.splice(this.row.cells, cellInx, 1, cells);
  };
}(jQuery, LNX_INCIDENT_PLANNING, LNX_UTILS));
