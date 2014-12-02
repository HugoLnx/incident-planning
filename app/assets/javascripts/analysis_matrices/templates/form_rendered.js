(function($, namespace) {
  var Templates = namespace.AnalysisMatrix.Templates;

  Templates.FormRendered = function($inputsTds, $submitRow) {
    this._$inputsTds = $inputsTds;
    this._$submitRow = $submitRow;
  };

  var _prototype = Templates.FormRendered.prototype;

  _prototype.$inputsTds = function() {
    return this._$inputsTds;
  };

  _prototype.$inputsRow = function() {
    return this._$inputsTds.first().closest("tr");
  };

  _prototype.$submitRow = function() {
    return this._$submitRow;
  };

  _prototype.$inputs = function() {
    return this._$inputsTds.find("input");
  };

  _prototype.$submit = function() {
    return this._$submitRow.find(".submit .update-btn");
  };

  _prototype.$deleteBtn = function() {
    return this._$submitRow.find(".submit .delete-btn");
  };

  _prototype.$cancelBtn = function() {
    return this._$submitRow.find(".submit .cancel-btn");
  };

}(jQuery, LNX_INCIDENT_PLANNING));
