describe("Matrix.Cell", function() {
  var Matrix = namespace().Matrix;
  var Spec = namespace().Spec;

  describe("function methods", function() {
    describe("when building many cells from tds", function() {
      it("initialize a cell to each <td>", function() {
        var $tds = $("<td id='one'></td><td id='two'></td>");
        var cells = Matrix.Cell.buildAll($tds);

        expect(cells[0].$element).toEqual($tds.first());
        expect(cells[1].$element).toEqual($tds.last());
      });
    });
  });

  describe("given a loaded cell", function() {
    beforeEach(function() {
      var cells = Spec.Factories.Cell.buildInSameRow(3);

      this.cell = cells[1];
      this.$td = this.cell.$element;
      this.$tdBefore = cells[0].$element;
      this.$tdAfter = cells[2].$element;
      this.row = this.cell.row;
    });

    describe("when replacing with others cells", function() {
      beforeEach(function() {
        var $newTds = $("<td>One</td><td>Two</td>");
        var cells = Matrix.Cell.buildAll($newTds);
        this.cell.replaceWith(cells);

        this.$newTds = $newTds;
      });

      it("destroys yourself", function() {
        expect(this.$td).not.toBeInDOM();
      });

      it("insert the new tds in the same place", function() {
        expect(this.$tdBefore.next()).toEqual(this.$newTds.first());
        expect(this.$tdAfter.prev()).toEqual(this.$newTds.last());
      });

      it("insert the new cells in the same order", function() {
        expect(this.row.cells[1].$element).toEqual(this.$newTds.first());
        expect(this.row.cells[2].$element).toEqual(this.$newTds.last());
      });
    });
  });
});
