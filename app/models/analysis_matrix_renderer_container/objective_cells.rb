module AnalysisMatrixRendererContainer
  class ObjectiveCells
    attr_reader :objective
    attr_reader :repeated

    def initialize(objective=nil, repeated=nil, last_child=nil, last_repetition=nil)
      @objective = objective
      @repeated = repeated
      @last_child = last_child
      @last_repetition = last_repetition
    end

    def self.from(row, strategy_cells)
      ObjectiveCells.new(
        row.objective,
        row.has_objective_repeated?,
        row.has_objective_as_last_child?,
        strategy_cells.is_a?(StrategyCells::New)
      )
    end

    def self.from_previous(row, is_last_repetition: false)
      ObjectiveCells.new(
        row.objective,
        true,
        row.has_objective_as_last_child?,
        is_last_repetition
      )
    end

    def render_using(callbacks)
      callbacks.call(:show_objective, @objective, @repeated, @last_child, @last_repetition)
    end
  end
end
