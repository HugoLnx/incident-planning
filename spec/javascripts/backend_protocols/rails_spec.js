describe("AnalysisMatrix.BackendProtocols.Rails", function() {
  var Factories = namespace().Spec.Factories;
  var AuthenticityToken = namespace().BackendProtocols.AuthenticityToken;

  describe("given an instance", function() {
    describe("when getting params to request controller", function() {
      it("adds param specific to the http method", function() {
        var railsProtocol = Factories.Rails.build({method: "PUT"});
        var params = railsProtocol.params();
        expect(params._method).toEqual("PUT");
      });

      it("adds authenticity token param", function() {
        var railsProtocol = Factories.Rails.build();
        var token = new AuthenticityToken("token");
        spyOn(AuthenticityToken, "getFromMetatag").and.returnValue(token);

        var params = railsProtocol.params();
        expect(params.authenticity_token).toEqual("token");
      });
    });

    describe("when getting http method for browser", function() {
      describe("for get", function() {
        it("returns GET", function() {
          var railsProtocol = Factories.Rails.build({method: "get"});
          expect(railsProtocol.httpMethodForBrowser()).toEqual("GET");
        });
      });

      describe("anything different from get", function() {
        it("returns POST", function() {
          var railsProtocolPost = Factories.Rails.build({method: "post"})
          var railsProtocolPut = Factories.Rails.build({method: "put"})
          var railsProtocolDelete = Factories.Rails.build({method: "delete"})

          expect(railsProtocolPost.httpMethodForBrowser()).toEqual("POST");
          expect(railsProtocolPut.httpMethodForBrowser()).toEqual("POST");
          expect(railsProtocolDelete.httpMethodForBrowser()).toEqual("POST");
        });
      });
    });
  });
});
