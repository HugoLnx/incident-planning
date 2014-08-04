(function($, namespace) {
  $.widget("LNX.errorsDialog", $.ui.dialog, {
    options: {
      title: "Item Issues",
      hide: true,
      closeText: "",
      close: function() {
        $(this).remove();
      }
    }
  });
}(jQuery, LNX_INCIDENT_PLANNING));
