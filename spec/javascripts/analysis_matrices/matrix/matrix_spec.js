var Matrix = namespace().Matrix.Matrix;

describe("Matrix.Matrix", function() {
  describe("when initialized based in a existent table", function() {
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

    it("have a cell to each <td> in table", function() {
      var cell0 = this.matrix.rows[0].cells[0];
      var cell1 = this.matrix.rows[1].cells[0];
      var cell2 = this.matrix.rows[2].cells[0];
      var $tds = this.$trs.find("td");

      expect(cell0.$element[0]).toEqual($tds[0]);
      expect(cell1.$element[0]).toEqual($tds[1]);
      expect(cell2.$element[0]).toEqual($tds[2]);
    });
  });

  describe("given a loaded matrix", function() {
    beforeEach(function() {
      window.loadFixtures("matrix.html");
      var $table = $("#matrix");
      var $trs = $table.find(".data-row");
      var matrix = new Matrix($table, $trs);

      this.$table = $table;
      this.$trs = $trs;
      this.matrix = matrix;
    });

    it("find rows by trs elements", function() {
        var rowsFound = this.matrix.findRows(this.$trs.slice(0, 2));
        
        expect(rowsFound[0]).toEqual(this.matrix.rows[0]);
        expect(rowsFound[1]).toEqual(this.matrix.rows[1]);
    });

    it("find cells by tds elements", function() {
        var $tds = this.$trs.find("td");
        var cellsFound = this.matrix.findCells($tds.slice(0, 2));
        
        expect(cellsFound[0]).toEqual(this.matrix.rows[0].cells[0]);
        expect(cellsFound[1]).toEqual(this.matrix.rows[1].cells[0]);
    });

    it("discover row number", function() {
      expect(this.matrix.rowNumber(this.matrix.rows[0])).toBe(0);
      expect(this.matrix.rowNumber(this.matrix.rows[1])).toBe(1);
      expect(this.matrix.rowNumber(this.matrix.rows[2])).toBe(2);
    });

    it("discover cell number", function() {
      var cell1 = this.matrix.rows[0].cells[0];
      var cell2 = this.matrix.rows[1].cells[0];

      expect(this.matrix.cellNumber(cell1)).toBe(0);
      expect(this.matrix.cellNumber(cell2)).toBe(0);
    });

    it("find cells by tds elements", function() {
        var $tds = this.$trs.find("td");
        var cellsFound = this.matrix.findCells($tds.slice(0, 2));
        
        expect(cellsFound[0]).toEqual(this.matrix.rows[0].cells[0]);
        expect(cellsFound[1]).toEqual(this.matrix.rows[1].cells[0]);
    });

    describe("when inserting a row with determined number", function() {
      beforeEach(function() {
        var $newTr = $("<tr class='data-row'><td>NewName</td></tr>");
        this.$newTr = $newTr;
      });

      describe("if already have row with this number", function() {
        beforeEach(function() {
          this.matrix.insertRow(this.$newTr, 1);
          var $updatedTrs = $(".data-row");

          this.$updatedTrs = $updatedTrs;
        });

        it("insert before the current", function() {
          expect(this.$updatedTrs[1]).toEqual(this.$newTr[0]);
          expect(this.$updatedTrs[2]).toEqual(this.$trs[1]);
        });

        it("update matrix rows", function() {
          expect(this.matrix.rows[1].$element).toEqual(this.$newTr);
        });
      });

      describe("if does not have row with this number", function() {
        beforeEach(function() {
          this.matrix.insertRow(this.$newTr, 30);
          var $updatedTrs = $(".data-row");

          this.$updatedTrs = $updatedTrs;
        });

        it("insert as last row", function() {
          expect(this.$updatedTrs.last()).toEqual(this.$newTr);
        });

        it("update matrix rows", function() {
          expect(this.matrix.rows[3].$element).toEqual(this.$newTr);
        });
      });

    });
  });

});
