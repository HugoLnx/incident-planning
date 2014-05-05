(function($) {
  $.fn.asShowDialogButton = function() {
    var $btns = this;

    $btns.show();
    $(".dialog-title").hide();
    $btns.each(function() {
      var dialogId = $(this).data("dialog-id");
      var $dialogElement = $(document.getElementById(dialogId));
      $dialogElement.hide();
    });

    $btns.on("click", function(event) {
      event.preventDefault();

      var $btn = $(this);
      var dialogId = $btn.data("dialog-id");

      var $dialogElement = $(document.getElementById(dialogId));
      var $titleElement = $dialogElement.siblings(".dialog-title");
      if ($titleElement.length !== 0) {
        $dialogElement.data("dialog-title", $titleElement.text());
      }
      $dialogElement.dialog({
          title: $dialogElement.data("dialog-title"),
          hide: true,
          closeText: "",
          position: {
            my: "left top",
            at: "left bottom",
            of: $btn
          }
      });
    });
  }
} (jQuery));
