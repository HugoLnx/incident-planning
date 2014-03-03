(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;

  Templates.NewTactic = function() { };

  var _prototype = Templates.NewTactic.prototype;
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

    var $inputs = $inputsTds.find("input");
    var $submit = $submitRow.find(".submit .update-btn");
    var $deleteBtn = $submitRow.find(".submit .delete-btn");
    return new Templates.FormRendered($inputs, $submit, $deleteBtn);
  };

  function inputsHtml(values) {
    var html = ""
    html += inputHtml("who", values.who || "");
    html += inputHtml("what", values.what || "");
    html += inputHtml("where", values.where || "");
    html += inputHtml("when", values.when || "");
    html += inputHtml("response_action", values.response_action || "");
    return html;
  };

  function inputHtml(name, value) {
    var class_name = name.replace(/_/g, "-");
    var html = '<td class="tactic form ' + class_name + '">';
    html += '<input name="tactic[' + name + ']" value="' + value + '" />';
    html += '</td>';
    return html;
  }

  function submitHtml(submitName, withDelete) {
    var html = '<tr>';
    html += '<td class="objective submit-side"></td>';
    html += '<td colspan="2" class="strategy submit-side"></td>';
    html += '<td colspan="5" class="tactic form submit">';
    html +=   '<button class="update-btn">' + submitName + '</button>';
    if (withDelete) {
      html +=   '<button class="delete-btn">Delete</button>';
    }
    html += '</td>';
    html += '</tr>';
    return html;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
