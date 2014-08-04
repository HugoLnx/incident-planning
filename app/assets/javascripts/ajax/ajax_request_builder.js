(function($, namespace) {
  var Ajax = namespace.Ajax;

  Ajax.AjaxRequestBuilder = function() {
    this.$inputs = $([]);
  };

  var _prototype = Ajax.AjaxRequestBuilder.prototype;
  _prototype.addParams = function(params) {
    for (var key in params) {
      if (params.hasOwnProperty(key)) {
        var $input = inputHtml(key, params[key]);
        this.$inputs = this.$inputs.add($input)
      }
    }
  };

  _prototype.addParamsFromInputs = function($inputs) {
    this.$inputs = this.$inputs.add($inputs);
  };

  _prototype.paramsToUrl = function() {
    return $("<form>")
      .append(this.$inputs.clone())
      .serialize();
  };

  function inputHtml(name, value) {
    return $("<input type='hidden'>")
      .attr("name", name)
      .val(value);
  }

}(jQuery, LNX_UTILS));
