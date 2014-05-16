module AnalysisMatrixRendererContainer
  class StrategyCells
    def self.from(row, tactic_cells)
      if row.strategy
        StrategyCells::Show.new(
          row.strategy,
          row.has_strategy_repeated?,
          row.has_strategy_as_last_child?,
          tactic_cells.is_a?(TacticCells::New)
        )
      else
        StrategyCells::New.new(row.objective.group_id)
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

    class Show
      def initialize(strategy=nil, repeated=nil, last_child=false, last_repetition=false)
        @strategy = strategy
        @repeated = repeated
        @last_child = last_child
        @last_repetition = last_repetition
      end

      def render_using(callbacks)
        callbacks.call(:show_strategy, @strategy, @repeated, @last_child, @last_repetition)
      end
    end

    class New
      def initialize(father_id)
        @father_id = father_id
      end

      def render_using(callbacks)
        callbacks.call(:new_strategy, @father_id)
      end
    end
  end
end
