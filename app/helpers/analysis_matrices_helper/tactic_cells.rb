module AnalysisMatricesHelper
  class TacticCells
    def self.from(context, row)
      if row.strategy.nil?
        self.blank(context)
      elsif row.tactic
        TacticCells::Show.new(context, row.tactic, row.has_tactic_repeated?)
      else
        TacticCells::New.new(context)
      end
    end

    def self.blank(context)
      TacticCells::Show.new(context)
    end

    class Show
      PARTIAL = "tactic_cells"

      def initialize(context, tactic=nil, repeated=nil)
        @context = context
        @tactic = tactic
        @repeated = repeated
      end

      def render
        texts = {
          who:   @tactic && @tactic.who   && @tactic.who.text,
          what:  @tactic && @tactic.what  && @tactic.what.text,
          where: @tactic && @tactic.where && @tactic.where.text,
          when:  @tactic && @tactic.when  && @tactic.when.time,
          response_action: @tactic && @tactic.response_action && @tactic.response_action.text
        }
        repeated_class = @repeated ? "repeated" : ""
        @context.render partial: PARTIAL, locals: {texts: texts, repeated: repeated_class}
      end
    end

    class New
      PARTIAL = "new_tactic_form_cells"

      def initialize(context)
        @context = context
      end

      def render
        @context.render partial: PARTIAL
      end
    end
  end
end
