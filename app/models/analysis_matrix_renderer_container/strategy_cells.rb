module AnalysisMatrixRendererContainer
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
      def initialize(strategy=nil, repeated=nil)
        @strategy = strategy
        @repeated = repeated
      end

      def render_using(callbacks)
        callbacks.call(:show_strategy, @strategy, @repeated)
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
