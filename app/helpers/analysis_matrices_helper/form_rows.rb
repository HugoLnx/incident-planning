module AnalysisMatricesHelper
  class FormRows
    attr_reader :row, :previous_row

    def initialize(context, row=nil, previous_row=nil)
      @row = row
      @previous_row = previous_row
      @context = context
    end

    def build_rows
      return [] if first_iteration?

      rows = []

      if last_tactic_of_current_strategy?
        rows << new_tactic_row
      end

      if last_strategy_of_current_objective?
        rows << new_strategy_row
      end

      rows
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
      tactic_cells = TacticCells::New.new(@context)
      objective_cells = ObjectiveCells.from_previous(@context, previous_row)
      strategy_cells = StrategyCells.from_previous(@context, previous_row)
      AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)
    end

    def new_strategy_row
      strategy_cells = StrategyCells::New.new(@context, previous_row.objective.group_id)
      objective_cells = ObjectiveCells.from_previous(@context, previous_row)
      tactic_cells = TacticCells.blank(@context)
      AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)
    end
  end
end
