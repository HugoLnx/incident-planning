(function($) {
  $(function() {
  // update td class when select value change
    var CRITICALITIES_CLASSES = ["high","medium", "low"];
    var CRITICALITIES = {H:CRITICALITIES_CLASSES[0], M:CRITICALITIES_CLASSES[1], L:CRITICALITIES_CLASSES[2]};

    $(".criticality select").change(function(event) {
      event.preventDefault();
      updateClassUsingNewValueOfSelect(this);
    });

    function updateClassUsingNewValueOfSelect(selectEl) {
      var $select = $(selectEl);
      var newValue = $select.val();

      var $td = $select.closest(".criticality");
      $td.removeClass(CRITICALITIES_CLASSES.join(" "));
      $td.addClass(CRITICALITIES[newValue]);
    }

  // send ajax request when select value change
    $(".criticality select").change(function(event) {
      event.preventDefault();
      sendAjaxRequestUpdatingSelect(this);
    });

    function sendAjaxRequestUpdatingSelect(selectEl) {
      var $select = $(selectEl);
      var $critComp = $select.closest(".group-criticality");
      var groupId = $critComp.data("group-id");
      $.post("/criticalities/" + groupId, {value: $select.val(), _method: "PUT"}, function(criticalities) {
        popupSaved($select);
        updateAllCriticalities(criticalities);
      });
    }

    function popupSaved($element) {
      var $div = $("<div class='saved-popup'>Saved!</div>");
      $element.after($div);
      $div.fadeOut(2000, function(){$div.remove();});
    }
    
    function updateAllCriticalities(criticalities) {
      var l = criticalities.length;
      for(var i = 0; i < l; i++) {
        var crit = criticalities[i];
        var $select = $("#criticality-of-" + crit.group_id + " select");
        $select.val(crit.criticality);
        updateClassUsingNewValueOfSelect($select.get());
      }
    }
  });
}(jQuery));
