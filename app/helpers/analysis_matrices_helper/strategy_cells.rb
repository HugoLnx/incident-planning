module AnalysisMatricesHelper
  class StrategyCells
    def self.from(context, row)
      if row.strategy
        StrategyCells::Show.new(context, row.strategy, row.has_strategy_repeated?)
      else
        StrategyCells::New.new(context)
      end
    end

    def self.from_previous(context, row)
      StrategyCells::Show.new(context, row.strategy, true)
    end

    class Show
      PARTIAL = "strategy_cells"

      def initialize(context, strategy=nil, repeated=nil)
        @context = context
        @strategy = strategy
        @repeated = repeated
      end

      def render
        texts = {
          how: @strategy && @strategy.how && @strategy.how.text,
          why: @strategy && @strategy.why && @strategy.why.text
        }
        repeated_class = @repeated ? "repeated" : ""
        @context.render partial: PARTIAL, locals: {texts: texts, repeated: repeated_class}
      end
    end

    class New
      PARTIAL = "new_strategy_form_cells"

      def initialize(context)
        @context = context
      end

      def render
        @context.render partial: PARTIAL
      end
    end
  end
end
