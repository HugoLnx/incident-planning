var AjaxRequestBuilder = utilsNamespace().Ajax.AjaxRequestBuilder;

describe("AjaxRequestBuilder", function() {

  describe("given an instance", function() {
    beforeEach(function() {
      this.builder = new AjaxRequestBuilder();
    });

    describe("when adding params via object", function() {
      beforeEach(function() {
        this.builder.addParams({param1: "value1"});
      });

      it("become keys and values of the params", function() {
        expect(this.builder.paramsToUrl()).toEqual("param1=value1");
      });
    });

    describe("when adding params via inputs", function() {
      beforeEach(function() {
        var $inputs = $("<input>")
          .attr("name", "inputparam")
          .val("inputvalue");
        this.builder.addParamsFromInputs($inputs);
      });

      it("use the name and value as keys and values of the params", function() {
        expect(this.builder.paramsToUrl()).toEqual("inputparam=inputvalue");
      });
    });
  });
});
