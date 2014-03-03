(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;

  Templates.NewStrategy = function(){};

  var _prototype = Templates.NewStrategy.prototype;

  _prototype.renderIn = function(matrix, cells, opts) {
    var opts = opts || {};
    var defaultData = opts.defaultData || {};
    var submitName = opts.submitButton;
    var withDelete = opts.withDelete || false;
    var iRow = matrix.rowNumber(cells[0].row);

    var $submitRow = $(submitHtml(submitName, withDelete));
    var row = matrix.insertRow($submitRow, iRow+1);

    var $inputsTds = $(inputsHtml(defaultData));
    var inputCells = Matrix.Cell.buildAll($inputsTds);
    Matrix.Cell.replaceWith(cells, inputCells);

    return new Templates.FormRendered($inputsTds.find("input"), $submitRow.find(".submit .update-btn"));
  };

  function inputsHtml(values) {
    var html = '';
    html += inputHtml("how", values.how || "");
    html += inputHtml("why", values.why || "");
    return html;
  };

  function inputHtml(name, value) {
    var html = '<td class="strategy form ' + name + '">';
    html += '<input name="strategy[' + name + ']" value="' + value + '" />';
    html += '</td>';
    return html;
  }

  function submitHtml(buttonName, withDelete) {
    var html = '<tr>';
    html += '<td class="objective submit-side"></td>';
    html += '<td colspan="2" class="strategy form submit">';
    html +=   '<button class="update-btn">' + buttonName + '</button>';
    if (withDelete) {
      html +=   '<button class="delete-btn">Delete</button>';
    }
    html += '</td>';
    html += '<td colspan="5" class="tactic submit-side"></td>';
    html += '</tr>';
    return html;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
