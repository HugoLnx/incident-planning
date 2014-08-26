(function($) {
  $(function() {
    $(".criticality select").change(function(event) {
      event.preventDefault();
      var $select = $(this);
      var $critComp = $select.closest(".group-criticality");
      var groupId = $critComp.data("group-id");
      $.post("/criticalities/" + groupId, {value: $select.val(), _method: "PUT"}, function(criticalities) {
        var $div = $("<div class='saved-popup'>Saved!</div>");
        $select.after($div);
        $div.fadeOut(2000, function(){$div.remove();});
        var l = criticalities.length;
        for(var i = 0; i < l; i++) {
          var crit = criticalities[i];
          $("#criticality-of-" + crit.group_id + " select").val(crit.criticality);
        }
      });
    });
  });
}(jQuery));
