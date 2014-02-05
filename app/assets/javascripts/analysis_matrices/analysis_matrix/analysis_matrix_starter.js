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
      var $tr = $td.parent("tr");

      var row = $(matrix.matrix.rows).filter(function() {
        return this.$element[0] === $tr[0];
      })[0];

      var cell = $(row.cells).filter(function() {
        return this.$element[0] === $td[0];
      })[0];
      Actions.AddStrategy.bindIn(cell);
    });

    return matrix;
  };
}(jQuery, LNX_INCIDENT_PLANNING));

