module AnalysisMatrixRendererContainer
  class Row
    attr_reader :objective_cells, :strategy_cells, :tactic_cells

    def self.from_cells(objective_cells, strategy_cells, tactic_cells, callbacks)
      self.new(
        CellsRenderer.new(objective_cells, callbacks),
        CellsRenderer.new(strategy_cells, callbacks),
        CellsRenderer.new(tactic_cells, callbacks)
      )
    end
    
    def initialize(objective_cells, strategy_cells, tactic_cells)
      @objective_cells = objective_cells
      @strategy_cells = strategy_cells
      @tactic_cells = tactic_cells
    end
  end
end
