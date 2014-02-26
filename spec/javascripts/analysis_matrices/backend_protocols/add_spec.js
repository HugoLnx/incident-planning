describe("AnalysisMatrix.BackendProtocols.Add", function() {
  var Factories = namespace().Spec.Factories;
  var Add = namespace().AnalysisMatrix.BackendProtocols.Add;
  var AuthenticityToken = namespace().BackendProtocols.AuthenticityToken;

  describe("given an instance", function() {
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

      it("adds param specific to the http method", function() {
        var addProtocol = Factories.Add.build({method: "PUT"});
        var params = addProtocol.params($([]));
        expect(params._method).toEqual("PUT");
      });

      it("adds authenticity token param", function() {
        var addProtocol = Factories.Add.build();
        var token = new AuthenticityToken("token");
        spyOn(AuthenticityToken, "getFromMetatag").and.returnValue(token);

        var params = addProtocol.params($([]));
        expect(params.authenticity_token).toEqual("token");
      });
    });

    describe("when getting http method for browser", function() {
      describe("for get", function() {
        it("returns GET", function() {
          var addProtocol = Factories.Add.build({method: "get"});
          expect(addProtocol.httpMethodForBrowser()).toEqual("GET");
        });
      });

      describe("anything different from get", function() {
        it("returns POST", function() {
          var addProtocolPost = Factories.Add.build({method: "post"})
          var addProtocolPut = Factories.Add.build({method: "put"})
          var addProtocolDelete = Factories.Add.build({method: "delete"})

          expect(addProtocolPost.httpMethodForBrowser()).toEqual("POST");
          expect(addProtocolPut.httpMethodForBrowser()).toEqual("POST");
          expect(addProtocolDelete.httpMethodForBrowser()).toEqual("POST");
        });
      });
    });
  });
});
