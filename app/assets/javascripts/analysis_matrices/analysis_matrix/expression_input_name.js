(function($, namespace) {
  var AnalysisMatrix = namespace.AnalysisMatrix;

  AnalysisMatrix.ExpressionInputName = function(group, attr) {
    this._group = group;
    this._attr = attr;
  };

  var _function = AnalysisMatrix.ExpressionInputName;

  _function.parseName = function(name) {
    var match = name.match(/^(.*)\[(.*)\]/)
    var groupName = match[1];
    var attrName = match[2];
    return new AnalysisMatrix.ExpressionInputName(groupName, attrName);
  };

  var _prot = AnalysisMatrix.ExpressionInputName.prototype;

  _prot.attr = function(attr) {
    if (attr === undefined) {
      return this._attr;
    } else {
      this._attr = attr;
    }
  };

  _prot.toString = function() {
    return this._group + "[" + this._attr + "]";
  };


}(jQuery, LNX_INCIDENT_PLANNING));
