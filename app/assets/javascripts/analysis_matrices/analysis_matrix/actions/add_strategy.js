(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;

  Actions.AddStrategy = function(cell, $father) {
    this.$father = $father;
    this.cell = cell;
  };

  var _func = Actions.AddStrategy;
  _func.bindIn = function(cell, $father) {
    cell.$element.on("click", $father, function(event) {
      event.preventDefault();

      var newCells = $("<td><input/></td><td><input/></td>");
      cell.replaceWith(Matrix.Cell.buildAll(newCells));
    });

    return new Actions.AddStrategy(cell, $father);
  };

}(jQuery, LNX_INCIDENT_PLANNING));
