(function($, namespace) {
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var AuthenticityToken = namespace.BackendProtocols.AuthenticityToken;

  BackendProtocols.Add = function(opts) {
    this.form_father_id_param_name = opts.form_father_id_param_name;
    this.father_id_data_attr_name = opts.father_id_data_attr_name;
    this.method = opts.method.toUpperCase();
  };

  var _function = BackendProtocols.Add;

  _function.strategyProtocol = function() {
    return new BackendProtocols.Add({
      form_father_id_param_name: "strategy[father_id]",
      father_id_data_attr_name: "father_id",
      method: "post"
    });
  };

  var _prototype = BackendProtocols.Add.prototype;
  _prototype.httpMethodForBrowser = function() {
    if (this.method == "GET") {
      return "GET";
    } else {
      return "POST";
    }
  };

  _prototype.params = function($element) {
    var params = {};

    $.extend(params, fatherIdParam(this, $element));
    $.extend(params, methodParam(this));
    $.extend(params, authenticityTokenParam());

    return params;
  };

  function fatherIdParam(self, $element) {
    var father_id = $element.attr("data-"+self.father_id_data_attr_name);
    var param = {};
    param[self.form_father_id_param_name] = father_id;
    return param;
  }

  function methodParam(self) {
    return {_method: self.method};
  }

  function authenticityTokenParam() {
    var authenticityToken = AuthenticityToken.getFromMetatag();
    return authenticityToken.asParam();
  }

}(jQuery, LNX_INCIDENT_PLANNING));
