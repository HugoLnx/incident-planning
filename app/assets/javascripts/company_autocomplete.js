//= require jquery.ui.autocomplete

$(function() {
  $(".autocomplete-company-input").each(function() {
    var $input = $(this);
    var $hidden = $input.clone();
    $hidden.attr("type", "hidden");
    $input.attr("name", "user[company_name]");
    $input.after($hidden);

    $input.autocomplete({
      minLength: 0,
      source: function(request, response) {
        $.get("/companies.json", function(companies){
          var options = [];
          for(var i = 0; i<companies.length; i++) {
            var company = companies[i];
            options.push({
              label: company.name,
              value: company.id
            });
            var results = $.ui.autocomplete.filter(options, request.term);
            response(results);
          }
        });
      },
      select: function(event, ui) {
        event.preventDefault();
        $input.val(ui.item.label);
        $hidden.val(ui.item.value);
      },
      focus: function(event, ui) {
        event.preventDefault();
      }
    });
  });
});
