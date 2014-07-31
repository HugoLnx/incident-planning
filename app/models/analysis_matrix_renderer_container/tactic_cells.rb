module AnalysisMatrixRendererContainer
  class TacticCells
    def self.from(row)
      if row.strategy.nil?
        self.blank
      elsif row.tactic
        TacticCells::Show.new(
          row.tactic,
          row.has_tactic_repeated?,
          last_child: row.has_tactic_as_last_child?,
          last_repetition: true
        )
      else
        TacticCells::New.new(row.strategy.group_id)
      end
    end

    def self.blank
      TacticCells::Show.new(blank: true)
    end

    class Show
      CALLBACK_NAME = :show_tactic

      attr_reader :tactic
      attr_reader :repeated

      def initialize(tactic=nil, repeated=nil, last_child: false, last_repetition: false, blank: false)
        @tactic = tactic
        @repeated = repeated
        @last_child = last_child
        @last_repetition = last_repetition
        @blank = blank
      end

      def callback_name
        CALLBACK_NAME
      end

      def callback_args
        [@tactic, @repeated, @last_child, @last_repetition, @blank]
      end
    end

    class New
      CALLBACK_NAME = :new_tactic

      def initialize(father_id)
        @father_id = father_id
      end

      def callback_name
        CALLBACK_NAME
      end

      def callback_args
        [@father_id]
      end
    end
  end
end
