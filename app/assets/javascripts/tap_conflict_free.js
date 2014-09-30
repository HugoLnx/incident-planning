(function($, namespace) {
  var TapConflictFree = namespace.TapConflictFree;

  TapConflictFree.wrapAction = function(actionFunction) {
    return function(event) {
      event.preventDefault();

      var element = this;
      var timeoutId = setTimeout(function() {
        if(!$(element).data("doubletap.doubletapped")) {
          actionFunction.call(element, event);
        }
        $(element).data("doubletap.doubletapped", false)
      }, 250);
      $(element).hammer().on("doubletap.avoid-tap-conflict", function(event) {
        $(this).data("doubletap.doubletapped", true);
        clearTimeout(timeoutId);
        $(element).hammer().off("doubletap.avoid-tap-conflict");
      });
    };
  };
} (jQuery, LNX_UTILS));
