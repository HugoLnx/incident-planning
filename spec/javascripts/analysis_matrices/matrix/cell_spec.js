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

      it("can set the row of all cells", function() {
        var $tds = $("<td id='one'></td><td id='two'></td>");
        var row = "mockRow"
        var cells = Matrix.Cell.buildAll($tds, row);

        expect(cells[0].row).toEqual(row);
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

    describe("when extracting data", function() {
      beforeEach(function() {
        var cell0 = Spec.Factories.Cell.build({html: {class: "how", text: "value1"}});
        var cell1 = Spec.Factories.Cell.build({html: {class: "who", text: "value2"}});
        var cell2 = Spec.Factories.Cell.build({html: {class: "what"}});
        var cells = [cell0, cell1, cell2];
        this.data = Matrix.Cell.extractData(cells);
      });

      it("associate expression name and the text in element", function() {
        expect(this.data.how).toEqual("value1");
        expect(this.data.who).toEqual("value2");
      });

      describe("when element is empty", function() {
        it("associate to undefined", function() {
          expect(this.data.what).toEqual(undefined);
        });
      });
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

    describe("when getting the expression name", function() {
      it("if have a objective class", function() {
        var name = "objective";
        var cell = Spec.Factories.Cell.build({html: {class: name}});
        expect(cell.expressionName()).toEqual(name);
      });

      it("if have a how class", function() {
        var name = "how";
        var cell = Spec.Factories.Cell.build({html: {class: name}});
        expect(cell.expressionName()).toEqual(name);
      });

      it("if have a why class", function() {
        var name = "why";
        var cell = Spec.Factories.Cell.build({html: {class: name}});
        expect(cell.expressionName()).toEqual(name);
      });

      it("if have a who class", function() {
        var name = "who";
        var cell = Spec.Factories.Cell.build({html: {class: name}});
        expect(cell.expressionName()).toEqual(name);
      });

      it("if have a what class", function() {
        var name = "what";
        var cell = Spec.Factories.Cell.build({html: {class: name}});
        expect(cell.expressionName()).toEqual(name);
      });

      it("if have a where class", function() {
        var name = "where";
        var cell = Spec.Factories.Cell.build({html: {class: name}});
        expect(cell.expressionName()).toEqual(name);
      });

      it("if have a when class", function() {
        var name = "when";
        var cell = Spec.Factories.Cell.build({html: {class: name}});
        expect(cell.expressionName()).toEqual(name);
      });

      it("if have a response-action class", function() {
        var name = "response-action";
        var cell = Spec.Factories.Cell.build({html: {class: name}});
        expect(cell.expressionName()).toEqual("response_action");
      });
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
