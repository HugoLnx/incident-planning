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

  describe("when replacing some cells with others", function() {
    beforeEach(function() {
      var row = Spec.Factories.Row.build();
      var allCells = Spec.Factories.Cell.buildPushingToRow(row, {qnt: 5});

      this.cellBefore = allCells[0];
      this.cells = allCells.slice(1, 4);
      this.cellAfter = allCells[4];
      this.row = this.cellBefore.row;

      var newCells = Spec.Factories.Cell.build({qnt: 2});
      var $newTds = $($.map(newCells, function(cell){return cell.$element[0];}));
      this.$newTds = $newTds;

      Matrix.Cell.replaceWith(this.cells, newCells);
    });

    it("destroy replaced cells", function() {
      expect(this.cells[0].$element).not.toBeInDOM();
      expect(this.cells[1].$element).not.toBeInDOM();
      expect(this.cells[2].$element).not.toBeInDOM();
    });

    it("insert the new tds in the same place", function() {
      expect(this.cellBefore.$element.next()).toEqual(this.$newTds.first());
      expect(this.cellAfter.$element.prev()).toEqual(this.$newTds.last());
    });

    it("insert the new cells in the same order", function() {
      expect(this.row.cells[1].$element).toEqual(this.$newTds.first());
      expect(this.row.cells[2].$element).toEqual(this.$newTds.last());
    });
  });

  describe("given a loaded cell", function() {
    beforeEach(function() {
      var row = Spec.Factories.Row.build();
      var cells = Spec.Factories.Cell.buildPushingToRow(row, {qnt: 3});

      this.cellBefore = cells[0];
      this.cell = cells[1];
      this.cellAfter = cells[2];
      this.row = this.cell.row;
    });

    describe("when replacing with others cells", function() {
      beforeEach(function() {
        var cells = Spec.Factories.Cell.build({qnt: 2});
        this.cell.replaceWith(cells);
        var $newTds = $($.map(cells, function(cell){return cell.$element[0];}));

        this.$newTds = $newTds;
      });

      it("destroys yourself", function() {
        expect(this.cell.$element).not.toBeInDOM();
      });

      it("insert the new tds in the same place", function() {
        expect(this.cellBefore.$element.next()).toEqual(this.$newTds.first());
        expect(this.cellAfter.$element.prev()).toEqual(this.$newTds.last());
      });

      it("insert the new cells in the same order", function() {
        expect(this.row.cells[1].$element).toEqual(this.$newTds.first());
        expect(this.row.cells[2].$element).toEqual(this.$newTds.last());
      });
    });
  });
});
