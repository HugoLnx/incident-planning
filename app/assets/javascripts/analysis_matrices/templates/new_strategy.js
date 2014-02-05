(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;

  Templates.NewStrategy = function($inputsTds, $submitTd) {
    this.$inputsTds = $inputsTds;
    this.$submitTd = $submitTd;
  };

  var _func = Templates.NewStrategy;

  _func.renderIn = function(matrix, cell) {
    var iRow = matrix.matrix.rowNumber(cell.row);

    var $submitRow = $(submitHtml());
    var row = matrix.matrix.insertRow($submitRow, iRow+1);

    var $inputsTds = $(inputsHtml());
    cell.replaceWith(Matrix.Cell.buildAll($inputsTds));

    return new Templates.NewStrategy($inputsTds, $submitRow.find(".submit"));
  };

  function inputsHtml() {
    var html = '<td class="strategy form how"><input/></td>';
    html += '<td class="strategy form why"><input/></td>';
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
