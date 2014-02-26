(function($, namespace) {
  var BackendProtocols = namespace.AnalysisMatrix.BackendProtocols;
  var Rails = namespace.BackendProtocols.Rails;
  var Matrix = namespace.Matrix;

  BackendProtocols.Update = function(opts) {
    this._update_path_data_attr_name = opts.update_path_data_attr_name;
    this._method = opts.method.toUpperCase();
    this._railsProtocol = new Rails(this._method);
  };

  var _function = BackendProtocols.Update;

  _function.defaultProtocol = function() {
    return new BackendProtocols.Update({
      update_path_data_attr_name: "update_path",
      method: "put"
    });
  };

  var _prototype = BackendProtocols.Update.prototype;
  _prototype.path = function($element) {
    return $element.data(this._update_path_data_attr_name);
  };

  _prototype.httpMethodForBrowser = function() {
    return this._railsProtocol.httpMethodForBrowser();
  };

  _prototype.params = function($element) {
    return this._railsProtocol.params();
  };

  _prototype.currentData = function(cells) {
    return Matrix.Cell.extractData(cells);
  };

}(jQuery, LNX_INCIDENT_PLANNING));
