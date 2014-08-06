module AnalysisMatrixRendererContainer
  class RowsIterator
    def initialize(matrix_data, callbacks: {})
      @matrix_data = matrix_data
      @callbacks = Callbacks.new(callbacks)
    end

    def each_row(&block)
      previous_row = nil

      @matrix_data.each_row do |row|
        form_rows = FormRows.new(@callbacks, row, previous_row)
        form_rows.build_rows.each{|extra_row| yield extra_row}

        tactic_cells = TacticCells.from(row)
        strategy_cells = StrategyCells.from(row, tactic_cells, @callbacks)
        objective_cells = ObjectiveCells.from(row, strategy_cells)

        yield AnalysisMatrixRendererContainer::Row.from_cells(objective_cells, strategy_cells, tactic_cells, @callbacks)

        previous_row = row
      end

      form_rows = FormRows.new(@callbacks, nil, previous_row)
      form_rows.build_rows.each{|extra_row| yield extra_row}
    end

    def rows
      rows = []
      each_row{|row| rows << row}
      rows
    end
  end
end
