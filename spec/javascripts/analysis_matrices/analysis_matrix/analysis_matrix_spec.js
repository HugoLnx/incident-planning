describe("AnalysisMatrix.AnalysisMatrix", function() {
  var AnalysisMatrix = namespace().AnalysisMatrix.AnalysisMatrix;

  describe("function methods", function() {
    describe("when build from table element", function() {
      beforeEach(function() {
        loadFixtures("matrix.html");
        var $table = $("#matrix");
        var matrix = AnalysisMatrix.buildFromTable($table);

        this.$table = $table;
        this.matrix = matrix;
      });

      it("doesn't use the two first <tr> in table", function() {
        var $trs = this.$table.find("tr");
        expect(this.matrix.matrix.rows[0].$element[0]).toEqual($trs[2]);
      });
    });
  });
});
