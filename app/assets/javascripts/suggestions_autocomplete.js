(function($, namespace) {
  var Reuse = namespace.AnalysisMatrix.Reuse;

  $.widget("LNX.suggestionsAutocomplete", $.ui.autocomplete, {
    options: {
      minLength: 0,
      create: function(event, ui) {
        var $input = $(this);
        var currentSource = $input.suggestionsAutocomplete("option", "source");
        $input.data("originalSource", currentSource);
        $input.on("keypress", function() {
          Reuse.InputRenderer.becameNonReused($input);
        });
      },
      change: function(event, ui) {
        var $input = $(this);
        var userHasSelectedAnItem = ui.item !== null;
        if (!userHasSelectedAnItem) {
          Reuse.InputRenderer.becameNonReused($input);
        }
      },
      focus: function(event, ui) {
        event.preventDefault();
      },
      select: function(event, ui) {
        event.preventDefault();
        var $input = $(this);
        var item = ui.item;
        if (item.count === 1) {
          Reuse.InputRenderer.becameReused($input, item.text, item.value);
        } else {
          $input.data("lnxautocomplete-reopen", true);
          $input.suggestionsAutocomplete("option", "source", item.childs);
        }
      },
      close: function(event, ui) {
        var $input = $(this);
        if ($input.data("lnxautocomplete-reopen")) {
          $input.data("lnxautocomplete-reopen", false);
          setTimeout(function(){
            $input.suggestionsAutocomplete("search", "");
          }, 100);
        } else {
          $input.suggestionsAutocomplete("option", "source", $input.data("originalSource"));
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
