module AnalysisMatrixRendererContainer
  class Row
    attr_reader :objective_cells, :strategy_cells, :tactic_cells
    
    def initialize(objective_cells, strategy_cells, tactic_cells)
      @objective_cells = objective_cells
      @strategy_cells = strategy_cells
      @tactic_cells = tactic_cells
    end
  end
end
