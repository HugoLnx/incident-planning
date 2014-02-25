(function($, namespace) {
  var BackendProtocols = namespace.BackendProtocols;

  BackendProtocols.AuthenticityToken = function(value) {
    this._value = value;
  };

  var _function = BackendProtocols.AuthenticityToken;
  _function.getFromMetatag = function() {
    var value = $("meta[name='csrf-token']").attr("content");
    return new BackendProtocols.AuthenticityToken(value);
  };

  var _prototype = BackendProtocols.AuthenticityToken.prototype;
  _prototype.value = function() {
    return this._value;
  };

  _prototype.asParam = function() {
    return {"authenticity_token" : this.value()};
  };

}(jQuery, LNX_INCIDENT_PLANNING));
