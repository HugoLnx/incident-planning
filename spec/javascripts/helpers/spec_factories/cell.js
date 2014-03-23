(function($, namespace) {
  var Matrix = namespace.Matrix;

  var Factories = namespace.Spec.Factories;

  Factories.Cell = {
    buildPushingToRow: function(row, opts) {
      var opts = opts || {};
      var qnt = opts.qnt || 1;

      var cells = [];
      for(var i = 1; i <= qnt; i++) {
        var cell = buildOne(row);
        cells.push(cell);
        row.cells.push(cell);
        row.$element.append(cell.$element);
      }

      if (cells.length === 1) {
        return cells[0];
      } else {
        return cells;
      }
    },

    build: function(opts) {
      var opts = opts || {};
      var qnt = opts.qnt || 1;
      var row = opts.row || undefined;
      var htmlOpts = opts.html || {};

      var instances = []
      for(var i = 1; i <= qnt; i++) {
        instances.push(buildOne(row, htmlOpts));
      }

      if (instances.length === 1) {
        return instances[0];
      } else {
        return instances;
      }
    }
  };

  function buildOne(row, htmlOpts) {
    var htmlOpts = htmlOpts || {};
    var $textElement = $("<p>")
      .addClass("expression-text")
      .text(htmlOpts.text);

    var $td = $("<td>")
      .addClass(htmlOpts.class)
      .append($textElement);

    var cell = new Matrix.Cell($td, row);
    return cell
  }
  
}(jQuery, LNX_INCIDENT_PLANNING));
