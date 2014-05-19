(function($, namespace) {
  var EXPRESSION_NAMES = ["objective", "how", "why", "who", "what", "where", "when", "response_action"];
  var EXPRESSION_PRETTY_NAMES = ["Objective", "How", "Why", "Who", "What", "Where", "When", "ResponseAction"];

  var AnalysisMatrix = namespace.AnalysisMatrix;

  AnalysisMatrix.ExpressionRecognizer = function() {
  };

  var _function = AnalysisMatrix.ExpressionRecognizer;

  _function.getNameFromTd = function($element) {
    for(var i = 0; i<EXPRESSION_NAMES.length; i++) {
      var name = EXPRESSION_NAMES[i];
      if ($element.hasClass(name)) {
        return name;
      }
    }
  }

  _function.getPrettyNameFromTd = function($element) {
    var name = _function.getNameFromTd($element);
    return EXPRESSION_PRETTY_NAMES[EXPRESSION_NAMES.indexOf(name)];
  }

  _function.getPrettyNameFromInput = function($element) {
    for(var i = 0; i<EXPRESSION_NAMES.length; i++) {
      var name = EXPRESSION_NAMES[i];
      if ($element.attr("name").match(name)) {
        return EXPRESSION_PRETTY_NAMES[EXPRESSION_NAMES.indexOf(name)];
      }
    }
  }

}(jQuery, LNX_INCIDENT_PLANNING));
