(function($, namespace) {
  var Add = namespace.AnalysisMatrix.BackendProtocols.Add;

  var Factories = namespace.Spec.Factories;

  Factories.Add = {
    build: function(opts) {
      var opts = opts || {};

      var param_name = opts.form_father_id_param_name || "param_name";
      var attr_name = opts.father_id_data_attr_name || "attr_name";
      var method = opts.method || "post";
      var path = opts.path || "/whatever/path";
      var railsProtocol = opts.rails_protocol;

      var addProtocol = new Add({
        form_father_id_param_name: param_name,
        father_id_data_attr_name: attr_name,
        method: method,
        path: path
      });

      if (railsProtocol) {
        addProtocol._railsProtocol = railsProtocol;
      }

      return addProtocol;
    }
  };

}(jQuery, LNX_INCIDENT_PLANNING));
