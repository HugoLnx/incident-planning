(function($, namespace) {
  var Matrix = namespace.Matrix;
  var AnalysisMatrix = namespace.AnalysisMatrix;
  var Actions = namespace.AnalysisMatrix.Actions;

  AnalysisMatrix.AnalysisMatrixPublishedStarter = function() {
  };

  var _prototype = AnalysisMatrix.AnalysisMatrixPublishedStarter.prototype;

  _prototype.start = function($table) {
    var matrix = AnalysisMatrix.AnalysisMatrix.buildFromTable($table);

    Actions.ShowMetadata.defaultAction().bindIn($table, "Objective");
    Actions.ShowMetadata.defaultAction().bindIn($table, "Strategy");
    Actions.ShowMetadata.defaultAction().bindIn($table, "Tactic");

    return matrix;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
