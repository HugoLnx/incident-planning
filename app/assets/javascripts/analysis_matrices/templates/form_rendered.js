(function($, namespace) {
  var Templates = namespace.AnalysisMatrix.Templates;

  Templates.FormRendered = function($inputs, $submit) {
    this._$inputs = $inputs;
    this._$submit = $submit;
  };

  var _prototype = Templates.FormRendered.prototype;

  _prototype.$inputs = function() {
    return this._$inputs;
  };

  _prototype.$submit = function() {
    return this._$submit;
  };

}(jQuery, LNX_INCIDENT_PLANNING));
