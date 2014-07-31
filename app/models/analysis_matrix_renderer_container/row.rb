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

    def objective
      @objective_cells.cells
    end

    def strategy
      @strategy_cells.cells
    end

    def tactic
      @tactic_cells.cells
    end

    def can_be_rendered?
      @objective_cells.can_be_rendered? &&
      @strategy_cells.can_be_rendered? &&
      @tactic_cells.can_be_rendered?
    end
  end
end
