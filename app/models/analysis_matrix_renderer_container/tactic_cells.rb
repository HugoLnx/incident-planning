module AnalysisMatrixRendererContainer
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
      def initialize(tactic=nil, repeated=nil)
        @tactic = tactic
        @repeated = repeated
      end

      def render_using(callbacks)
        callbacks.call(:show_tactic, @tactic, @repeated)
      end
    end

    class New
      def render_using(callbacks)
        callbacks.call(:new_tactic)
      end
    end
  end
end
