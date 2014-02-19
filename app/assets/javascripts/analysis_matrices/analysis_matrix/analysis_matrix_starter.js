(function($, namespace) {
  var Matrix = namespace.Matrix;
  var AnalysisMatrix = namespace.AnalysisMatrix;
  var Actions = namespace.AnalysisMatrix.Actions;

  AnalysisMatrix.AnalysisMatrixStarter = function() {
  };

  var _prototype = AnalysisMatrix.AnalysisMatrixStarter.prototype;

  _prototype.start = function($table) {
    var matrix = AnalysisMatrix.AnalysisMatrix.buildFromTable($table);

    $table.find(".form.strategy").each(function() {
      var $td = $(this);

      var cell = matrix.matrix.findCells($td)[0];
      Actions.AddStrategy.bindIn(matrix, cell, $table);
    });

    $table.find(".form.tactic").each(function() {
      var $td = $(this);

      var cell = matrix.matrix.findCells($td)[0];
      Actions.AddTactic.bindIn(matrix, cell, $table);
    });

    return matrix;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
