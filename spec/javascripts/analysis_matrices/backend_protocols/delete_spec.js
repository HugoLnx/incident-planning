describe("AnalysisMatrix.BackendProtocols.Delete", function() {
  var Factories = namespace().Spec.Factories;
  var Delete = namespace().AnalysisMatrix.BackendProtocols.Delete;
  var Matrix = namespace().Matrix;

  describe("given an instance", function() {
    describe("when getting the url path to the service", function() {
      it("extract from element ", function() {
        var deleteProtocol = Factories.Delete.build({delete_path_data_attr_name: "attr_name"});
        var $element = $("<div>").attr("data-attr_name", "/a/path");
        expect(deleteProtocol.path($element)).toEqual("/a/path");
      });
    });

    describe("when getting params to request controller", function() {
      it("delegates to rails protocol", function() {
        var rails = Factories.Rails.build();
        spyOn(rails, 'params').and.returnValue("the_params");

        var deleteProtocol = Factories.Delete.build({rails_protocol: rails});

        expect(deleteProtocol.params()).toEqual("the_params");
        expect(rails.params).toHaveBeenCalled();
      });
    });

    describe("when getting http method for browser", function() {
      it("delegates do rails protocol", function() {
        var rails = Factories.Rails.build();
        spyOn(rails, 'httpMethodForBrowser').and.returnValue("GET");

        var deleteProtocol = Factories.Delete.build({rails_protocol: rails});

        expect(deleteProtocol.httpMethodForBrowser()).toEqual("GET");
        expect(rails.httpMethodForBrowser).toHaveBeenCalled();
      });
    });
  });
});
