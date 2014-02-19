module AnalysisMatrixRendererContainer
  class TacticCells
    def self.from(row)
      if row.strategy.nil?
        self.blank
      elsif row.tactic
        TacticCells::Show.new(row.tactic, row.has_tactic_repeated?)
      else
        TacticCells::New.new(row.strategy.group_id)
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
      def initialize(father_id)
        @father_id = father_id
      end

      def render_using(callbacks)
        callbacks.call(:new_tactic, @father_id)
      end
    end
  end
end
