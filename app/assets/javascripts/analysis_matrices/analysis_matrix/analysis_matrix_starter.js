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

    $table.find(".form.tactic").each(function() {
      var $td = $(this);

      var cell = matrix.matrix.findCells($td)[0];
      Actions.AddTactic.bindIn(matrix, cell, $table);
    });

    $table.find(".strategy.show.non-repeated").each(function() {
      var $tds = $(this).add($(this).siblings(".strategy"));

      var cells = matrix.matrix.findCells($tds);
      Actions.UpdateStrategy.bindIn(matrix, $(this), cells, $table);
    });

    return matrix;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
