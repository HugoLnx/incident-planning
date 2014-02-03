module AnalysisMatricesHelper
  class ObjectiveCells
    PARTIAL = "objective_cells"

    def initialize(context, objective=nil, repeated=nil)
      @context = context
      @objective = objective
      @repeated = repeated
    end

    def self.from(context, row)
      ObjectiveCells.new(context, row.objective, row.has_objective_repeated?)
    end

    def self.from_previous(context, row)
      ObjectiveCells.new(context, row.objective, true)
    end

    def render
      text = @objective && @objective.expression && @objective.expression.text
      repeated_class = @repeated ? "repeated" : ""
      @context.render partial: PARTIAL, locals: {text: text, repeated: repeated_class}
    end
  end
end
