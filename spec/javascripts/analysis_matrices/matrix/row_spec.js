describe("Matrix.Row", function() {
  var Row = namespace().Matrix.Row;
  var Spec = namespace().Spec;

  describe("function methods", function() {
    describe("when building with cells", function() {
      it("build a row based on <tr> and his <td> children", function() {
        var $tr = $("<tr><td></td></tr>");
        var row = Row.buildWithCells($tr);

        expect(row.cells[0].$element).toEqual($tr.find("td"));
      });
    });
  });

  describe("given a initialized row", function() {
    beforeEach(function() {
      var row = Spec.Factories.Row.build({cells: 1});
      
      this.$tr = row.$element;
      this.row = row;
    });

    describe("when pushing a new cell", function() {
      beforeEach(function() {
        var $td = $("<td>LostCell</td>");
        this.row.pushCell($td);
        var $tds = this.row.$element.find("td");

        this.$td = $td;
        this.$tds = $tds;
      });

      it("insert <td> as last", function() {
        expect(this.$tds.last()).toEqual(this.$td);
      });

      it("update cells array", function() {
        expect(this.row.cells[1].$element).toEqual(this.$td);
      });

      it("put row as father of cells", function() {
        expect(this.row.cells[1].row).toEqual(this.row);
      });
    });
  });
});
