(function($, namespace) {
  var Rails = namespace.BackendProtocols.Rails;

  var Factories = namespace.Spec.Factories;

  Factories.Rails = {
    build: function(opts) {
      var opts = opts || {};

      var method = opts.method || "post";

      return new Rails(method);
    }
  };

}(jQuery, LNX_INCIDENT_PLANNING));
