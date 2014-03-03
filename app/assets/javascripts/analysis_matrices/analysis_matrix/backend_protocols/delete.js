(function($, namespace) {
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var Rails = namespace.BackendProtocols.Rails;
  var Matrix = namespace.Matrix;

  BackendProtocols.Delete = function(opts) {
    this._delete_path_data_attr_name = opts.delete_path_data_attr_name;
    this._method = opts.method.toUpperCase();
    this._railsProtocol = new Rails(this._method);
  };

  var _function = BackendProtocols.Delete;

  _function.defaultProtocol = function() {
    return new BackendProtocols.Update({
      update_path_data_attr_name: "delete_path",
      method: "delete"
    });
  };

  var _prototype = BackendProtocols.Delete.prototype;
  _prototype.path = function($element) {
    return $element.data(this._delete_path_data_attr_name);
  };

  _prototype.httpMethodForBrowser = function() {
    return this._railsProtocol.httpMethodForBrowser();
  };

  _prototype.params = function($element) {
    return this._railsProtocol.params();
  };

}(jQuery, LNX_INCIDENT_PLANNING));
