//= require form_restorable_data
//= require multivalored_input

(function($) {
  $(function() {
    

    var objectivesComponent = LNX_UTILS.Forms.MultivaloredInput.applyOn(
      $(".objectives-inputs"), $(".add-objective-btn"), $("#objective-li-template"));

    $(".objectives-inputs").enableRestoreData({
      label: "Copy from previous cycle",
      metatag_name: "restorable_cycle_objectives_text",
      type: "multivalored-input",
      component: objectivesComponent
    });
    $("#cycle_priorities").enableRestoreData({
      label: "Copy from previous cycle",
      metatag_name: "restorable_cycle_priorities"
    });
  });
}(jQuery));
