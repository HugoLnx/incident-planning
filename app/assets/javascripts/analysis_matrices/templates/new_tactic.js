(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;

  Templates.NewTactic = function($inputsTds, $submitTd) {
    this.$inputsTds = $inputsTds;
    this.$submitTd = $submitTd;
  };

  var _func = Templates.NewTactic;

  _func.renderIn = function(matrix, cell) {
    var iRow = matrix.matrix.rowNumber(cell.row);

    var $submitRow = $(submitHtml());
    var row = matrix.matrix.insertRow($submitRow, iRow+1);

    var $inputsTds = $(inputsHtml());
    cell.replaceWith(Matrix.Cell.buildAll($inputsTds));

    return new Templates.NewTactic($inputsTds, $submitRow.find(".submit"));
  };

  function inputsHtml() {
    var html = '<td class="tactic form who"><input name="tactic[who]"/></td>';
    html += '<td class="tactic form what"><input name="tactic[what]"/></td>';
    html += '<td class="tactic form where"><input name="tactic[where]"/></td>';
    html += '<td class="tactic form when"><input name="tactic[when]"/></td>';
    html += '<td class="tactic form response-action"><input name="tactic[response-action]"/></td>';
    return html;
  };

  function submitHtml() {
    var html = '<tr>';
    html += '<td class="objective submit-side"></td>';
    html += '<td colspan="2" class="strategy submit-side"></td>';
    html += '<td colspan="5" class="tactic form submit"><button>Criar!</button></td>';
    html += '</tr>';
    return html;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
