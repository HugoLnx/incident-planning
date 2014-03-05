(function($, namespace) {
  var Matrix = namespace.Matrix;
  var Templates = namespace.AnalysisMatrix.Templates;
  var Model = namespace.Model;

  Templates.FormTemplate = function(opts) {
    var opts = opts || {};
    this.submitName = opts.submitButton;
    this.withDelete = opts.withDelete || false;
    this.groupModel = opts.groupModel;
  };

  var _function = Templates.FormTemplate;

  _function.newStrategy = function() {
    return newTemplate(Model.get().strategy);
  };

  _function.editStrategy = function() {
    return editTemplate(Model.get().strategy);
  };

  _function.newTactic = function() {
    return newTemplate(Model.get().tactic);
  };

  _function.editTactic = function() {
    return editTemplate(Model.get().tactic);
  };

  function newTemplate(model) {
    return new Templates.FormTemplate({
      submitButton: "Create",
      withDelete: false,
      groupModel: model
    });
  }

  function editTemplate(model) {
    return new Templates.FormTemplate({
      submitButton: "Update",
      withDelete: true,
      groupModel: model
    });
  }

  var _prototype = Templates.FormTemplate.prototype;

  _prototype.evaluate = function(defaultData) {
    var defaultData = defaultData || {};

    var $submitRow = $(submitHtml(this));
    var $inputsTds = $(inputsHtml(this, defaultData));

    return new Templates.FormRendered($inputsTds, $submitRow);
  };

  function inputsHtml(self, values) {
    var html = '';
    var groupName = self.groupModel.pretty_name;

    $.each(self.groupModel.expressions, function() {
      var exp = this;
      var expName = exp.pretty_name;
      html += inputHtml(groupName, expName, values[expName] || "");
    });
    return html;
  };

  function inputHtml(groupName, expName, value) {
    var html = '<td class="' + groupName + ' form ' + expName + '">';
    html += '<input name="' + groupName + '[' + expName + ']" value="' + value + '" />';
    html += '</td>';
    return html;
  }

  function submitHtml(self) {
    var html = '<tr>';

    html += '<td class="objective submit-side"></td>';
    html += buttonsCellsHtml(self, Model.get().strategy);
    html += buttonsCellsHtml(self, Model.get().tactic);

    html += '</tr>';
    return html;
  };

  function buttonsCellsHtml(self, cellsGroupModel) {
    var expressionsLength = cellsGroupModel.expressions.length;
    html = "";
    if (self.groupModel == cellsGroupModel) {
      html += '<td colspan="' + expressionsLength + '" class="' + cellsGroupModel.pretty_name + ' form submit">';
      html += buttonsHtml(self.submitName, self.withDelete);
    } else {
      html += '<td colspan="' + expressionsLength + '" class="' + cellsGroupModel.pretty_name + ' form submit-side">';
    }

    html += '</td>';
    return html
  }

  function buttonsHtml(buttonName, withDelete) {
    html = "";
    html += '<button class="update-btn">' + buttonName + '</button>';
    if (withDelete) {
      html += '<button class="delete-btn">Delete</button>';
    }
    html += '<button class="cancel-btn">Cancel</button>';
    return html;
  }
}(jQuery, LNX_INCIDENT_PLANNING));
