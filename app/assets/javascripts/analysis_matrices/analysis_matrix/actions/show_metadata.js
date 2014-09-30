(function($, namespace, utils) {
  var Actions = namespace.AnalysisMatrix.Actions;
  var TapConflictFree = utils.TapConflictFree;
  var ENVIRONMENT = namespace.FROM_RAILS.environment;
  var ExpressionRecognizer = namespace.AnalysisMatrix.ExpressionRecognizer;

  Actions.ShowMetadata = function() {
    this.bindIn = function(_$father, _expression_model_name) {
      var _expression_model_prettyname = _expression_model_name.toLowerCase();
      var selector = "." + _expression_model_prettyname + ".non-repeated";

      if (ENVIRONMENT === "test") {
        _$father.on("click", selector, displayMetadata);
      } else {
        _$father.hammer().on("tap", selector, TapConflictFree.wrapAction(displayMetadata));
      }

      function displayMetadata(event) {
        event.preventDefault();
        var title = _expression_model_name;
        if (title === "Tactic") {
          title = title + " " + ExpressionRecognizer.getPrettyNameFromTd($(this));;
        }

        $(this).find(".metadata").clone().dialog({
          title: title,
          hide: true,
          closeText: "",
          position: {
            my: "left top",
            at: "left bottom",
            of: this
          },
          close: function() {
            $(this).remove();
          }
        });
      }
    };
  };

  Actions.ShowMetadata.defaultAction = function() {
    return new Actions.ShowMetadata();
  };

}(jQuery, LNX_INCIDENT_PLANNING, LNX_UTILS));
