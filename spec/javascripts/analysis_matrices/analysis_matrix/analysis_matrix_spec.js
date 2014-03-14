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

  describe("given a loaded matrix", function() {
    beforeEach(function() {
      var $table = $("matrix.html");
      var matrix = AnalysisMatrix.buildFromTable($table);

      this.$table = $table;
      this.matrix = matrix;
    });

    describe("when creating a new row", function() {
      beforeEach(function() {
        var row = this.matrix.newRow(1);

        this.row = row;
      });

      it("create a row with an cell to each column", function() {
        expect(this.row.cells.length).toEqual(AnalysisMatrix.COLS);
      });

      it("create a td to each column", function() {
        var $tr = this.row.$element;

        expect($tr.find("td").length).toEqual(AnalysisMatrix.COLS);
      });
    });
  });
});
