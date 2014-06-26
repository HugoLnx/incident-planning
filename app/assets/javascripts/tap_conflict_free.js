(function($, namespace) {
  var TapConflictFree = namespace.TapConflictFree;

  TapConflictFree.wrapAction = function(actionFunction) {
    return function(event) {
      event.preventDefault();

      var element = this;
      var timeoutId = setTimeout(function() {
        actionFunction.call(element, event);
      }, 250);
      $(element).hammer().on("doubletap.avoid-tap-conflict", function(event) {
        clearTimeout(timeoutId);
        $(element).hammer().off("doubletap.avoid-tap-conflict");
      });
    };
  };
} (jQuery, LNX_UTILS));
