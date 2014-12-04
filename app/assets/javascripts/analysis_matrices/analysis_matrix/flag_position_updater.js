(function($, namespace) {
  var AnalysisMatrix = namespace.AnalysisMatrix;

  AnalysisMatrix.FlagPositionUpdater = function() {
  };

  var _function = AnalysisMatrix.FlagPositionUpdater;

  _function.updateFlag = function() {
    $(".approvable-triangle").each(function() {
      var $triangleDiv = $(this);
      var $td = $triangleDiv.closest("td");
      var position = $td.offset()
      position.top += 2;
      position.left += 2;
      $triangleDiv.offset(position);
    });
  }

}(jQuery, LNX_INCIDENT_PLANNING));
