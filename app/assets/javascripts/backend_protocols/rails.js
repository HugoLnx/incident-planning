(function($, namespace) {
  var BackendProtocols = namespace.BackendProtocols;
  var AuthenticityToken = namespace.BackendProtocols.AuthenticityToken;

  BackendProtocols.Rails = function(method) {
    this._method = method.toUpperCase();
  };

  var _prototype = BackendProtocols.Rails.prototype;
  _prototype.httpMethodForBrowser = function() {
    if (this._method == "GET") {
      return "GET";
    } else {
      return "POST";
    }
  };

  _prototype.params = function($element) {
    var params = {};

    $.extend(params, methodParam(this._method));
    $.extend(params, authenticityTokenParam());

    return params;
  };

  function methodParam(method) {
    return {_method: method};
  }

  function authenticityTokenParam() {
    var authenticityToken = AuthenticityToken.getFromMetatag();
    return authenticityToken.asParam();
  }
} (jQuery, LNX_INCIDENT_PLANNING));
