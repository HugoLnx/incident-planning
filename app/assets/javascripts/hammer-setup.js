(function($) {
  Hammer.defaults.behavior.userSelect = "text";
  $.extend(Hammer.defaults, {
    drag: false,
    hold: false,
    transform: false
  });
}(jQuery));
