describe("AnalysisMatrix.BackendProtocols.Update", function() {
  var Factories = namespace().Spec.Factories;
  var Update = namespace().AnalysisMatrix.BackendProtocols.Update;
  var Matrix = namespace().Matrix;

  describe("given an instance", function() {
    describe("when getting the url path to the service", function() {
      it("extract from element ", function() {
        var updateProtocol = Factories.Update.build({update_path_data_attr_name: "attr_name"});
        var $element = $("<div>").attr("data-attr_name", "/a/path");
        expect(updateProtocol.path($element)).toEqual("/a/path");
      });
    });

    describe("when getting params to request controller", function() {
      it("delegates to rails protocol", function() {
        var rails = Factories.Rails.build();
        spyOn(rails, 'params').and.returnValue("the_params");

        var updateProtocol = Factories.Update.build({rails_protocol: rails});

        expect(updateProtocol.params()).toEqual("the_params");
        expect(rails.params).toHaveBeenCalled();
      });
    });

    describe("when getting http method for browser", function() {
      it("deletagets do rails protocol", function() {
        var rails = Factories.Rails.build();
        spyOn(rails, 'httpMethodForBrowser').and.returnValue("GET");

        var updateProtocol = Factories.Update.build({rails_protocol: rails});

        expect(updateProtocol.httpMethodForBrowser()).toEqual("GET");
        expect(rails.httpMethodForBrowser).toHaveBeenCalled();
      });
    });

    describe("when getting current data of cells", function() {
      it("delegate to Cell entity to extract from cells", function() {
        var updateProtocol = Factories.Update.build();
        var cellsMock = "cellsmock";
        var dataMock = "datamock"
        spyOn(Matrix.Cell, 'extractData').and.returnValue(dataMock);

        var dataReturned = updateProtocol.currentData(cellsMock);
        expect(dataReturned).toEqual(dataMock);
        expect(Matrix.Cell.extractData).toHaveBeenCalledWith(cellsMock);
      });
    });
  });
});
