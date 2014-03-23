(function($) {
  var HOLD_WAIT_DEFAULT = 500;

  $.fn.onHold = function(delegateSelector, whatToDo, miliseconds) {
    var miliseconds = miliseconds || HOLD_WAIT_DEFAULT;

    this.on("mousedown", delegateSelector, function(event) {
      var timeoutId = 0;
      var target = this;

      $(this).one("mouseup mouseleave", function(event) {
        clearTimeout(timeoutId);
      });

      timeoutId = setTimeout(function() {
        whatToDo.call(target, event);
      }, miliseconds);
    });
  };
}(jQuery));
