(function($, namespace) {
  var Matrix = namespace.Matrix;

  Matrix.Cell = function($element) {
    this.$element = $element;
  }



  var func = Matrix.Cell;

  func.newElement = function() {
    return $("<td>");
  };

}(jQuery, LNX_INCIDENT_PLANNING));
