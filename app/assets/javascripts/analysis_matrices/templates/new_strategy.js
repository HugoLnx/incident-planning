(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;
  var Model = namespace.Model;

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

    var $inputs = $inputsTds.find("input");
    var $submit = $submitRow.find(".submit .update-btn");
    var $deleteBtn = $submitRow.find(".submit .delete-btn");
    return new Templates.FormRendered($inputs, $submit, $deleteBtn);
  };

  function inputsHtml(values) {
    var html = '';
    $.each(Model.get().strategy.expressions, function() {
      var exp = this;
      var name = exp.pretty_name;
      html += inputHtml(name, values[name] || "");
    });
    return html;
  };

  function inputHtml(name, value) {
    var html = '<td class="strategy form ' + name + '">';
    html += '<input name="strategy[' + name + ']" value="' + value + '" />';
    html += '</td>';
    return html;
  }

  function submitHtml(buttonName, withDelete) {
    var strategy_exps = Model.get().strategy.expressions.length;
    var tactic_exps = Model.get().tactic.expressions.length;
    var html = '<tr>';
    html += '<td class="objective submit-side"></td>';
    html += '<td colspan="' + strategy_exps + '" class="strategy form submit">';
    html +=   '<button class="update-btn">' + buttonName + '</button>';
    if (withDelete) {
      html +=   '<button class="delete-btn">Delete</button>';
    }
    html += '</td>';
    html += '<td colspan="' + tactic_exps + '" class="tactic submit-side"></td>';
    html += '</tr>';
    return html;
  };
}(jQuery, LNX_INCIDENT_PLANNING));
