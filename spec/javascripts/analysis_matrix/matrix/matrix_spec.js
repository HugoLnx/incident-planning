var Matrix = namespace().Matrix.Matrix;

describe("Matrix.Matrix", function() {
  describe("based in a existent table", function() {
    beforeEach(function() {
      window.loadFixtures("matrix.html");
      var $table = $("#matrix");
      var $trs = $table.find(".data-row");
      var matrix = new Matrix($table, $trs);

      this.$table = $table;
      this.$trs = $trs;
      this.matrix = matrix;
    });

    it("have a row to each <tr> in table", function() {
      expect(this.matrix.rows[0].$element[0]).toEqual(this.$trs[0]);
      expect(this.matrix.rows[1].$element[0]).toEqual(this.$trs[1]);
      expect(this.matrix.rows[2].$element[0]).toEqual(this.$trs[2]);
    });
  });
});
