module AnalysisMatricesHelper
  def each_row(matrix_data, &block)
    previous_row = nil

    matrix_data.each_row do |row|
      form_rows = FormRows.new(self, row, previous_row)
      form_rows.build_rows.each{|extra_row| yield extra_row}

      objective_cells = ObjectiveCells.from(self, row)
      strategy_cells = StrategyCells.from(self, row)
      tactic_cells = TacticCells.from(self, row)

      yield AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)

      previous_row = row
    end

    form_rows = FormRows.new(nil, previous_row)
    form_rows.build_rows.each{|extra_row| yield extra_row}
  end

  class Row
    attr_reader :objective_cells, :strategy_cells, :tactic_cells
    
    def initialize(objective_cells, strategy_cells, tactic_cells)
      @objective_cells = objective_cells
      @strategy_cells = strategy_cells
      @tactic_cells = tactic_cells
    end
  end
end
