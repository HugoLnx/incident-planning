module AnalysisMatrixRendererContainer
  class ObjectiveCells
    def initialize(objective=nil, repeated=nil)
      @objective = objective
      @repeated = repeated
    end

    def self.from(row)
      ObjectiveCells.new(row.objective, row.has_objective_repeated?)
    end

    def self.from_previous(row)
      ObjectiveCells.new(row.objective, true)
    end

    def render_using(callbacks)
      callbacks.call(:show_objective, @objective, @repeated)
    end
  end
end
