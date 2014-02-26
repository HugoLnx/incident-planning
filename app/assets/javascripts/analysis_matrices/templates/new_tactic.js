(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;

  Templates.NewTactic = function() { };

  var _prototype = Templates.NewTactic.prototype;
  _prototype.renderIn = function(matrix, cells, opts) {
    var opts = opts || {};
    var submitName = opts.submitButton;

    var iRow = matrix.rowNumber(cells[0].row);

    var $submitRow = $(submitHtml(submitName));
    var row = matrix.insertRow($submitRow, iRow+1);

    var $inputsTds = $(inputsHtml());
    var inputCells = Matrix.Cell.buildAll($inputsTds);
    Matrix.Cell.replaceWith(cells, inputCells);

    return new Templates.FormRendered($inputsTds.find("input"), $submitRow.find(".submit button"));
  };

  function inputsHtml() {
    var html = '<td class="tactic form who"><input name="tactic[who]"/></td>';
    html += '<td class="tactic form what"><input name="tactic[what]"/></td>';
    html += '<td class="tactic form where"><input name="tactic[where]"/></td>';
    html += '<td class="tactic form when"><input name="tactic[when]"/></td>';
    html += '<td class="tactic form response-action"><input name="tactic[response_action]"/></td>';
    return html;
  };

  function submitHtml(submitName) {
    var html = '<tr>';
    html += '<td class="objective submit-side"></td>';
    html += '<td colspan="2" class="strategy submit-side"></td>';
    html += '<td colspan="5" class="tactic form submit"><button>' + submitName + '</button></td>';
    html += '</tr>';
    return html;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
