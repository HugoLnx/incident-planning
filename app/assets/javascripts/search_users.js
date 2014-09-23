//= require jquery.ui.autocomplete

(function($) {
  $(function() {
    var $input = $("input#filter");
    $input.autocomplete({
      source: function(request, response) {
        $.ajax({
          url: "/profiles.json",
          data: {filter: $input.val()},
          dataType: "json",
          success: function(users) {
            var vals = [];
            for(var i = 0; i<users.length; i++) {
              var user = users[i];
              vals.push({
                value: user.id,
                label: (user.email + " - " + user.name)
              });
            }
            response(vals);
          }
        });
      },
      select: function(event, ui){
        event.preventDefault();
        var item = ui.item;
        document.location.href = "/profiles/" + item.value;
      }
    });
  });
}(jQuery));
