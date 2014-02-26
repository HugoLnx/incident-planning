(function($, namespace) {
  var Matrix = namespace.Matrix;
  var AnalysisMatrix = namespace.AnalysisMatrix;
  var Actions = namespace.AnalysisMatrix.Actions;

  AnalysisMatrix.AnalysisMatrixStarter = function() {
  };

  var _prototype = AnalysisMatrix.AnalysisMatrixStarter.prototype;

  _prototype.start = function($table) {
    var matrix = AnalysisMatrix.AnalysisMatrix.buildFromTable($table);

    Actions.Add.strategyAction().bindIn(matrix.matrix, $table);

    Actions.Add.tacticAction().bindIn(matrix.matrix, $table);

    Actions.Update.strategyAction().bindIn(matrix.matrix, $table);

    Actions.Update.tacticAction().bindIn(matrix.matrix, $table);

    return matrix;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
