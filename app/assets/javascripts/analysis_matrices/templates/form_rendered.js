(function($, namespace) {
  var Templates = namespace.AnalysisMatrix.Templates;

  Templates.FormRendered = function($inputs, $submit, $deleteBtn) {
    this._$inputs = $inputs;
    this._$submit = $submit;
    this._$deleteBtn = $deleteBtn;
  };

  var _prototype = Templates.FormRendered.prototype;

  _prototype.$inputs = function() {
    return this._$inputs;
  };

  _prototype.$submit = function() {
    return this._$submit;
  };

  _prototype.$deleteBtn = function() {
    return this._$deleteBtn;
  };

}(jQuery, LNX_INCIDENT_PLANNING));
