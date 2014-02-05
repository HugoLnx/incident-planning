(function($, namespace) {
  var Matrix = namespace.Matrix;

  var Factories = namespace.Spec.Factories;

  Factories.Row = {
    build: function(opts) {
      var props = opts || {};
      var qnt = props.qnt || 1;
      var qntCells = props.cells || 0;

      var rows = [];
      for(var i = 1; i <= qnt; i++) {
        var row = new Matrix.Row($("<tr>"));
        for(var i = 1; i <= qntCells; i++) {
          pushCellOn(row);
        }
        rows.push(row);
      }

      if (rows.length === 1) {
        return rows[0];
      } else {
        return rows;
      }
    }
  };

  function pushCellOn(row) {
    var cell = Factories.Cell.build({row: row});
    row.cells.push(row);
  }
  
}(jQuery, LNX_INCIDENT_PLANNING));
