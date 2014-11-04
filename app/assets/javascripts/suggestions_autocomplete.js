(function($, namespace) {
  var Reuse = namespace.AnalysisMatrix.Reuse;

  var Options = function($input) {
    this.get = function(name) {
      return $input.suggestionsAutocomplete("option", name);
    };

    this.set = function(name, value) {
      return $input.suggestionsAutocomplete("option", name, value);
    };
  };

  $.widget("LNX.suggestionsAutocomplete", $.ui.autocomplete, {
    options: {
      minLength: 0,
      create: function(event, ui) {
        var $input = $(this);
        var opts = new Options($input);
        var currentSource = opts.get("source");
        $input.data("originalSource", currentSource);
        $input.on("keypress", function() {
          var isOnlyText = opts.get("onlyText");
          if (!isOnlyText) {
            Reuse.InputRenderer.becameNonReused($input);
          }
        });
      },
      change: function(event, ui) {
        var $input = $(this);
        var opts = new Options($input);
        var userHasSelectedAnItem = ui.item !== null;
        var isOnlyText = opts.get("onlyText");
        if (!userHasSelectedAnItem && !isOnlyText) {
          Reuse.InputRenderer.becameNonReused($input);
        }
      },
      focus: function(event, ui) {
        event.preventDefault();
      },
      select: function(event, ui) {
        event.preventDefault();
        var $input = $(this);
        var opts = new Options($input);
        var item = ui.item;
        if (item.count === 1) {
          var isOnlyText = opts.get("onlyText");
          if (isOnlyText) {
            $input.val(item.text);
          } else {
            Reuse.InputRenderer.becameReused($input, item.text, item.value);
          }
        } else {
          $input.data("lnxautocomplete-reopen", true);
          opts.set("source", item.childs);
        }
      },
      close: function(event, ui) {
        var $input = $(this);
        var opts = new Options($input);
        if ($input.data("lnxautocomplete-reopen")) {
          $input.data("lnxautocomplete-reopen", false);
          setTimeout(function(){
            $input.suggestionsAutocomplete("search", "");
          }, 100);
        } else {
          opts.set("source", $input.data("originalSource"));
        }
      }
    },
    _renderItem: function(ul, item) {
      var klass = (item.count !== 1 ? "multiple-instances" : "single-instance");
      return $("<li>")
        .append("<a>" + item.label + "</a>")
        .addClass(klass)
        .appendTo(ul);
    }
  });
}(jQuery, LNX_INCIDENT_PLANNING));
