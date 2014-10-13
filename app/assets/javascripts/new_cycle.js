//= require form_restorable_data
//= require multivalored_input
//= require ./analysis_matrices/analysis_matrix/expression_input_name
//= require ./analysis_matrices/analysis_matrix/reuse/input_renderer
//= require jquery.ui.autocomplete
//= require suggestions_autocomplete

(function($, namespace) {
  var FROM_RAILS = namespace.FROM_RAILS;

  $(function() {
    var objectivesComponent = LNX_UTILS.Forms.MultivaloredInput.applyOn({
      list: $(".objectives-inputs"),
      addBtn: $(".add-objective-btn"),
      templateScript: $("#objective-li-template"),
      afterAdd: function($li) {
        addObjectiveAutocomplete($li.find("input"));
      }
    });

    $(".objectives-inputs").enableRestoreData({
      label: "Copy from previous period",
      metatag_name: "restorable_cycle_objectives_text",
      type: "multivalored-input",
      component: objectivesComponent
    });
    $("#cycle_priorities").enableRestoreData({
      label: "Copy from previous period",
      metatag_name: "restorable_cycle_priorities"
    });

    addObjectiveAutocomplete($(".objectives-inputs input"));
  });

  function addObjectiveAutocomplete($element) {
    var source = "/incident/" + FROM_RAILS.current_incident_id + "/expression_suggestions/Objective";
    //"?expression_updated_id=" + expressionId;
    $element.suggestionsAutocomplete({
      source: source
    });
  }
}(jQuery, LNX_INCIDENT_PLANNING));
