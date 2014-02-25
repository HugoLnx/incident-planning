var AuthenticityToken = namespace().BackendProtocols.AuthenticityToken;

describe("AuthenticityToken", function() {
  describe("given a instance", function() {
    beforeEach(function() {
      this.token = new AuthenticityToken("token code");
    });

    describe("when getting as param", function() {
      it("returns an object like {'authenticity_token': 'token code'}", function() {
        expect(this.token.asParam()).toEqual({"authenticity_token": "token code"});
      });
    });
  });

  describe("as package of stactic functions", function() {
    describe("when get from metatag", function() {
      it("get the content of metatag with name 'csrf-token'", function() {
        window.loadFixtures("authenticity_token_metatag.html");
        var token = AuthenticityToken.getFromMetatag();
        expect(token.value()).toEqual("token code");
      });
    });
  });
});
