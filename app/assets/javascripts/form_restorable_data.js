(function($) {
    $.fn.enableRestoreData = function(opts) {
      var opts = opts || {};
      var defaultOpts = {
        label: "Restore data",
        metatag_name: "restorable_data",
        type: "text"
      };
      $.extend(defaultOpts, opts);

      var opts = defaultOpts;
      var type = opts.type;
      var $meta = $("meta[name=\"" + opts.metatag_name + "\"]");

      if ($meta.length !==0) {
        var $input = this;
        var $btn = $("<button>").text(opts.label);
        $input.before($btn);

        $btn.on("click", function(event) {
          event.preventDefault();

          if (type === "multivalored-input") {
            var component = opts.component;
            multivaloredRestore($input, $meta, component);
          } else {
            textRestore($input, $meta);
          }
        });
      }
    };

    function textRestore($input, $meta) {
      var restoredText = $meta.attr("content");
      $input.val(restoredText);
    }

    function multivaloredRestore($list, $meta, component) {
      var texts = JSON.parse($meta.attr("content"));
      component.replaceItems(texts);
    }
}(jQuery));
