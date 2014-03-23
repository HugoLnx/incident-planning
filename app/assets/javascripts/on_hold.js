(function($) {
  $.fn.onHold = function(delegateSelector, whatToDo, miliseconds) {
    var miliseconds = miliseconds || 1000;

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
