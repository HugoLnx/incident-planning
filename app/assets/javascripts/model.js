(function($, namespace) {
  var model;

  namespace.Model = {
    get: function() {
      if (!model) {
        model = namespace.FROM_RAILS.Model;
      }
      return model;
    }
  };
}(jQuery, LNX_INCIDENT_PLANNING));
