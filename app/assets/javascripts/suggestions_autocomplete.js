(function($) {
  $.widget("LNX.suggestionsAutocomplete", $.ui.autocomplete, {
    change: function(event, ui) {
      var userHasSelectedAnItem = ui.item !== null;
      if (!userHasSelectedAnItem) {
        Reuse.InputRenderer.becameNonReused($input);
      }
    },
    select: function(event, ui) {
      event.preventDefault();
      var item = ui.item;
      Reuse.InputRenderer.becameReused($input, item.label, item.value);
    },
    _renderItem: function(ul, item) {
      var klass = (item.count === 1 ? "single-instance" : "multiple-instances");
      return $("<li>")
        .append("<a>" + item.label + "</a>")
        .addClass(klass)
        .appendTo(ul);
    }
  });
}(jQuery));
