(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Actions = namespace.AnalysisMatrix.Actions;
  var Templates = namespace.AnalysisMatrix.Templates;

  Actions.AddStrategy = function(cell, $father) {
    this.$father = $father;
    this.cell = cell;
  };

  var _func = Actions.AddStrategy;
  _func.bindIn = function(matrix, cell, $father) {
    cell.$element.on("click", $father, function(event) {
      event.preventDefault();

      var template = Templates.NewStrategy.renderIn(matrix, cell);
    });

    return new Actions.AddStrategy(cell, $father);
  };

}(jQuery, LNX_INCIDENT_PLANNING));
