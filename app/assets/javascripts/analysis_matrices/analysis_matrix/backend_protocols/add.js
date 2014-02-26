(function($, namespace) {
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var AuthenticityToken = namespace.BackendProtocols.AuthenticityToken;

  BackendProtocols.Add = function(opts) {
    this._form_father_id_param_name = opts.form_father_id_param_name;
    this._father_id_data_attr_name = opts.father_id_data_attr_name;
    this._method = opts.method.toUpperCase();
    this._path = opts.path;
  };

  var _function = BackendProtocols.Add;

  _function.strategyProtocol = function() {
    return new BackendProtocols.Add({
      form_father_id_param_name: "strategy[father_id]",
      father_id_data_attr_name: "father_id",
      method: "post",
      path: namespace.FROM_RAILS.AnalysisMatrix.create_strategy_path
    });
  };

  _function.tacticProtocol = function() {
    return new BackendProtocols.Add({
      form_father_id_param_name: "tactic[father_id]",
      father_id_data_attr_name: "father_id",
      method: "post",
      path: namespace.FROM_RAILS.AnalysisMatrix.create_tactic_path
    });
  };

  var _prototype = BackendProtocols.Add.prototype;
  _prototype.path = function() {
    return this._path;
  };

  _prototype.httpMethodForBrowser = function() {
    if (this._method == "GET") {
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
    var father_id = $element.attr("data-"+self._father_id_data_attr_name);
    var param = {};
    param[self._form_father_id_param_name] = father_id;
    return param;
  }

  function methodParam(self) {
    return {_method: self._method};
  }

  function authenticityTokenParam() {
    var authenticityToken = AuthenticityToken.getFromMetatag();
    return authenticityToken.asParam();
  }

}(jQuery, LNX_INCIDENT_PLANNING));
