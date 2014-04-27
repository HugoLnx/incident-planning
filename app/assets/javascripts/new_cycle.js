//= require form_restorable_data

(function($) {
  $(function() {
    $("#cycle_objectives_text").enableRestoreData({
      label: "Copy from previous cycle",
      metatag_name: "restorable_cycle_objectives_text"
    });
    $("#cycle_priorities").enableRestoreData({
      label: "Copy from previous cycle",
      metatag_name: "restorable_cycle_priorities"
    });
  });
}(jQuery));
