module AnalysisMatrixRendererContainer
  class StrategyCells
    def self.from(row, tactic_cells, callbacks)
      if row.strategy
        StrategyCells::Show.new(
          row.strategy,
          row.has_strategy_repeated?,
          row.has_strategy_as_last_child?,
          tactic_cells.is_a?(TacticCells::New)
        )
      else
        if callbacks.has_callback?(StrategyCells::New::CALLBACK_NAME)
          StrategyCells::New.new(row.objective.group_id)
        else
          StrategyCells.blank
        end
      end
    end

    def self.from_previous(row, is_last_repetition: false)
      StrategyCells::Show.new(
        row.strategy,
        true,
        row.has_strategy_as_last_child?,
        is_last_repetition
      )
    end

    def self.blank
      StrategyCells::Show.new blank: true
    end

    class Show
      CALLBACK_NAME = :show_strategy

      attr_reader :strategy
      attr_reader :repeated
      attr_reader :blank

      def initialize(strategy=nil, repeated=nil, last_child=false, last_repetition=false, blank: false)
        @strategy = strategy
        @repeated = repeated
        @last_child = last_child
        @last_repetition = last_repetition
        @blank = blank
      end
 
      def callback_name
        CALLBACK_NAME
      end

      def callback_args
        [@strategy, @repeated, @last_child, @last_repetition, @blank]
      end
    end

    class New
      CALLBACK_NAME = :new_strategy

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
