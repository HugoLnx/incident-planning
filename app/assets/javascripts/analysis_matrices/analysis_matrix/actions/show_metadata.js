(function($, namespace) {
  var Actions = namespace.AnalysisMatrix.Actions;

  Actions.ShowMetadata = function() {
    this.bindIn = function(_$father, _expression_model_name) {
      var _expression_model_prettyname = _expression_model_name.toLowerCase();
      var selector = "." + _expression_model_prettyname + ".non-repeated";

      $(_$father).on("click", selector, function(event) {
        $(this).find(".metadata").clone().dialog({
          title: _expression_model_name,
          hide: true,
          position: {
            my: "left top",
            at: "left bottom",
            of: this
          },
          close: function() {
            $(this).remove();
          }
        });
      });
    };
  };

  Actions.ShowMetadata.defaultAction = function() {
    return new Actions.ShowMetadata();
  };

}(jQuery, LNX_INCIDENT_PLANNING));
