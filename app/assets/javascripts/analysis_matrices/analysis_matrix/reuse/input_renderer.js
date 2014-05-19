(function($, namespace) {
  var Reuse = namespace.AnalysisMatrix.Reuse;
  var ExpressionInputName = namespace.AnalysisMatrix.ExpressionInputName;

  var INPUT_REUSED_CLASS = "reused-input";
  var INPUT_NON_REUSED_CLASS = "non-reused-input"
  var HIDDEN_INPUT_NAME_SUFFIX = "_reused";
  var HIDDEN_INPUT_CLASS = "reused-expression-input";

  Reuse.InputRenderer = {}

  var _function = Reuse.InputRenderer;

  _function.becameReused = function($input, expressionText, expressionId) {
    if ($input.hasClass("reused-input")) {
      _function.becameNonReused($input);
    }
    $input.val(expressionText);
    var inputName = new ExpressionInputName.parseName($input.attr("name"));
    var expressionName = inputName.attr();
    inputName.attr(expressionName + HIDDEN_INPUT_NAME_SUFFIX)

    var $hiddenInput = $("<input>")
      .attr("type", "hidden")
      .addClass(HIDDEN_INPUT_CLASS)
      .addClass(expressionName)
      .attr("name", inputName.toString())
      .val(expressionId);

    $input.after($hiddenInput);
    $input.removeClass(INPUT_NON_REUSED_CLASS);
    $input.addClass(INPUT_REUSED_CLASS);
  };

  _function.becameNonReused = function($input) {
    var inputName = new ExpressionInputName.parseName($input.attr("name"));
    var expressionName = inputName.attr();
    $input.parent().find("." + HIDDEN_INPUT_CLASS + "." + expressionName).remove();
    $input.removeClass(INPUT_REUSED_CLASS);
    $input.addClass(INPUT_NON_REUSED_CLASS);
  };


}(jQuery, LNX_INCIDENT_PLANNING));
