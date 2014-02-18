module AnalysisMatricesHelper
  class ObjectiveCells
    PARTIAL = "objective_cells"

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

    def render(context: nil)
      text = @objective && @objective.expression && @objective.expression.text
      repeated_class = @repeated ? "repeated" : ""
      context.render partial: PARTIAL, locals: {text: text, repeated: repeated_class}
    end
  end
end
