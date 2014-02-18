module AnalysisMatrixRendererContainer
  class RowsIterator
    def initialize(matrix_data)
      @matrix_data = matrix_data
    end

    def each_row(&block)
      previous_row = nil

      @matrix_data.each_row do |row|
        form_rows = FormRows.new(row, previous_row)
        form_rows.build_rows.each{|extra_row| yield extra_row}

        objective_cells = ObjectiveCells.from row
        strategy_cells = StrategyCells.from row
        tactic_cells = TacticCells.from row

        yield AnalysisMatrixRendererContainer::Row.new(objective_cells, strategy_cells, tactic_cells)

        previous_row = row
      end

      form_rows = FormRows.new(nil, previous_row)
      form_rows.build_rows.each{|extra_row| yield extra_row}
    end
  end
end
