describe("AnalysisMatrix.BackendProtocols.Add", function() {
  var Factories = namespace().Spec.Factories;
  var Add = namespace().AnalysisMatrix.BackendProtocols.Add;

  describe("given an instance", function() {
    describe("when getting the url path to the service", function() {
      it("just returns the path received in constructor", function() {
        var addProtocol = Factories.Add.build({path: "/any/path"});
        expect(addProtocol.path()).toEqual("/any/path");
      });
    });

    describe("when getting params to request controller", function() {
      it("adds father_id extracted from the element", function() {
        var addProtocol = Factories.Add.build({
          father_id_data_attr_name: "id_data",
          form_father_id_param_name: "id_param"
        });

        var $element = $("<td>").attr("data-id_data", "123");
        var params = addProtocol.params($element);
        expect(params.id_param).toEqual("123");
      });

      it("adds params from rails protocol", function() {
        var rails = Factories.Rails.build({method: "PUT"});
        spyOn(rails, 'params').and.returnValue({rails_param: "rails_value"});

        var addProtocol = Factories.Add.build({rails_protocol: rails});

        var params = addProtocol.params($([]));
        expect(params.rails_param).toEqual("rails_value");
      });
    });

    describe("when getting http method for browser", function() {
      it("deletagets do rails protocol", function() {
        var rails = Factories.Rails.build();
        spyOn(rails, 'httpMethodForBrowser').and.returnValue("GET");

        var addProtocol = Factories.Add.build({rails_protocol: rails});

        expect(addProtocol.httpMethodForBrowser()).toEqual("GET");
      });
    });
  });
});
