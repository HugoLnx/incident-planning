module AnalysisMatricesHelper
  class Iteration
    attr_reader :row, :previous_row

    def initialize(row=nil, previous_row=nil)
      @row = row
      @previous_row = previous_row
    end

    def yield_extra_rows_with_forms(&block)
      return unless first_iteration?

      if last_tactic_of_current_strategy?
        yield new_tactic_row
      end

      if last_strategy_of_current_objective?
        yield new_strategy_row
      end
    end

    def first_iteration?
      previous_row.nil?
    end

  private

    def last_tactic_of_current_strategy?
      previous_row.tactic && (row.nil? || !row.has_strategy_repeated?)
    end

    def last_strategy_of_current_objective?
      previous_row.strategy && (row.nil? || !row.has_objective_repeated?)
    end

    def new_tactic_row
      tactic_cells = TacticCells::New.new(self)
      objective_cells = ObjectiveCells.from_previous(self, previous_row)
      strategy_cells = StrategyCells.from_previous(self, previous_row)
      AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)
    end

    def new_strategy_row
      strategy_cells = StrategyCells::New.new(self)
      objective_cells = ObjectiveCells.from_previous(self, previous_row)
      tactic_cells = TacticCells.blank(self)
      AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)
    end
  end
end
