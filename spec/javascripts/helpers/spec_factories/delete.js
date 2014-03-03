(function($, namespace) {
  var Delete = namespace.AnalysisMatrix.BackendProtocols.Delete;

  var Factories = namespace.Spec.Factories;

  Factories.Delete = {
    build: function(opts) {
      var opts = opts || {};

      var attr_name = opts.delete_path_data_attr_name || "attr_name";
      var method = opts.method || "delete";
      var railsProtocol = opts.rails_protocol;

      var deleteProtocol = new Delete({
        delete_path_data_attr_name: attr_name,
        method: method
      });

      if (railsProtocol) {
        deleteProtocol._railsProtocol = railsProtocol;
      }

      return deleteProtocol;
    }
  };

}(jQuery, LNX_INCIDENT_PLANNING));
