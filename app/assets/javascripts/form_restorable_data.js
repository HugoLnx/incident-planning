(function($) {
    $.fn.enableRestoreData = function(opts) {
      var opts = opts || {};
      var defaultOpts = {
        label: "Restore data",
        metatag_name: "restorable_data"
      };
      $.extend(defaultOpts, opts);

      var opts = defaultOpts;
      var $input = this;
      var $btn = $("<button>").text(opts.label);
      $input.before($btn);

      $btn.on("click", function(event) {
        event.preventDefault();

        var restoredText = $("meta[name=\"" + opts.metatag_name + "\"]").attr("content");
        $input.val(restoredText);
      });
    };
}(jQuery));
