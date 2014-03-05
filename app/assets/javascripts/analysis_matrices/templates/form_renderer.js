(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;
  var Model = namespace.Model;

  Templates.FormRenderer = function(matrix) {
    this.matrix = matrix;
  };

  var _prototype = Templates.FormRenderer.prototype;

  _prototype.render = function(form, opts) {
    var cellsToReplace = opts.replacing || [];
    var renderization = buildRenderOperation(this.matrix, cellsToReplace, form);

    renderization.execute();

    form.$cancelBtn().on("click", function() {
      renderization.back();
    });
  }

  function buildRenderOperation(matrix, cells, form) {
    var iRow = matrix.rowNumber(cells[0].row);
    var inputCells = Matrix.Cell.buildAll(form.$inputsTds(), cells[0].row);

    var renderization = new Templates.RenderOperation(matrix, {
      newRow: {
        $element: form.$submitRow(),
        number: iRow + 1
      },
      cells: {
        olds: cells,
        news: inputCells
      }
    });

    return renderization;
  }
} (jQuery, LNX_INCIDENT_PLANNING));
