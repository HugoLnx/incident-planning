(function($, namespace) {
  var Matrix = namespace.Matrix;

  var Factories = namespace.Spec.Factories;

  Factories.Cell = {
    buildInSameRow: function(number) {
      var qnt = number || 1;

      var row = new Matrix.Row($("<tr>"));

      for(var i = 1; i <= qnt; i++) {
        row.pushCell($("<td>"));
      }

      return row.cells;
    }
  };
  
}(jQuery, LNX_INCIDENT_PLANNING));
