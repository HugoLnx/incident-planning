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
        var cell = Spec.Factories.Cell.build();
        this.row.pushCell(cell);
        var $tds = this.row.$element.find("td");

        this.$tds = $tds;
        this.cell = cell;
      });

      it("insert <td> as last", function() {
        expect(this.$tds.last()).toEqual(this.cell.$element);
      });

      it("update cells array", function() {
        expect(this.row.cells[1].$element).toEqual(this.cell.$element);
      });

      it("put row as father of cells", function() {
        expect(this.row.cells[1].row).toEqual(this.row);
      });
    });
  });
});
