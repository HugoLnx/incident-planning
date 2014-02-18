module AnalysisMatricesHelper
  class TacticCells
    def self.from(row)
      if row.strategy.nil?
        self.blank
      elsif row.tactic
        TacticCells::Show.new(row.tactic, row.has_tactic_repeated?)
      else
        TacticCells::New.new
      end
    end

    def self.blank
      TacticCells::Show.new
    end

    class Show
      PARTIAL = "tactic_cells"

      def initialize(tactic=nil, repeated=nil)
        @tactic = tactic
        @repeated = repeated
      end

      def render(context: nil)
        texts = {
          who:   @tactic && @tactic.who   && @tactic.who.text,
          what:  @tactic && @tactic.what  && @tactic.what.text,
          where: @tactic && @tactic.where && @tactic.where.text,
          when:  @tactic && @tactic.when  && @tactic.when.time,
          response_action: @tactic && @tactic.response_action && @tactic.response_action.text
        }
        repeated_class = @repeated ? "repeated" : ""
        context.render partial: PARTIAL, locals: {texts: texts, repeated: repeated_class}
      end
    end

    class New
      PARTIAL = "new_tactic_form_cells"

      def render(context: nil)
        context.render partial: PARTIAL
      end
    end
  end
end
