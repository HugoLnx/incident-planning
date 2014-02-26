(function($, namespace) {
  var Update = namespace.AnalysisMatrix.BackendProtocols.Update;

  var Factories = namespace.Spec.Factories;

  Factories.Update = {
    build: function(opts) {
      var opts = opts || {};

      var attr_name = opts.update_path_data_attr_name || "attr_name";
      var method = opts.method || "post";
      var railsProtocol = opts.rails_protocol;

      var updateProtocol = new Update({
        update_path_data_attr_name: attr_name,
        method: method
      });

      if (railsProtocol) {
        updateProtocol._railsProtocol = railsProtocol;
      }

      return updateProtocol;
    }
  };

}(jQuery, LNX_INCIDENT_PLANNING));
