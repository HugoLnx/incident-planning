module AnalysisMatricesHelper
  class StrategyCells
    def self.from(row)
      if row.strategy
        StrategyCells::Show.new(row.strategy, row.has_strategy_repeated?)
      else
        StrategyCells::New.new(row.objective.group_id)
      end
    end

    def self.from_previous(row)
      StrategyCells::Show.new(row.strategy, true)
    end

    class Show
      PARTIAL = "strategy_cells"

      def initialize(strategy=nil, repeated=nil)
        @strategy = strategy
        @repeated = repeated
      end

      def render(context: nil)
        texts = {
          how: @strategy && @strategy.how && @strategy.how.text,
          why: @strategy && @strategy.why && @strategy.why.text
        }
        repeated_class = @repeated ? "repeated" : ""
        context.render partial: PARTIAL, locals: {texts: texts, repeated: repeated_class}
      end
    end

    class New
      PARTIAL = "new_strategy_form_cells"

      def initialize(father_id)
        @father_id = father_id
      end

      def render(context: nil)
        context.render partial: PARTIAL, locals: {father_id: @father_id}
      end
    end
  end
end
