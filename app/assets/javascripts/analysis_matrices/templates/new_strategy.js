(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;

  Templates.NewStrategy = function($inputsTds, $submitTd) {
    this.$inputsTds = $inputsTds;
    this.$submitTd = $submitTd;
  };

  var _func = Templates.NewStrategy;

  _func.renderIn = function(matrix, cells) {
    var iRow = matrix.matrix.rowNumber(cells[0].row);

    var $submitRow = $(submitHtml());
    var row = matrix.matrix.insertRow($submitRow, iRow+1);

    var $inputsTds = $(inputsHtml());
    var inputCells = Matrix.Cell.buildAll($inputsTds);
    Matrix.Cell.replaceWith(cells, inputCells);

    return new Templates.NewStrategy($inputsTds, $submitRow.find(".submit"));
  };

  function inputsHtml() {
    var html = '<td class="strategy form how"><input name="strategy[how]"/></td>';
    html += '<td class="strategy form why">';
    html +=   '<input name="strategy[why]"/>';
    html += '</td>';
    return html;
  };

  function submitHtml() {
    var html = '<tr>';
    html += '<td class="objective submit-side"></td>';
    html += '<td colspan="2" class="strategy form submit"><button>Criar!</button></td>';
    html += '<td colspan="5" class="tactic submit-side"></td>';
    html += '</tr>';
    return html;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
