module AnalysisMatricesHelper
  def each_row(matrix_data, &block)
    first_row = true

    matrix_data.each_row do |row|
      objective_cells = render partial: "objective_cells", locals: {objective: row.objective}
      strategy_cells = render partial: "strategy_cells", locals: {strategy: row.strategy}
      tactic_cells = render partial: "tactic_cells", locals: {tactic: row.tactic}

      unless first_row
        if row.objective
          form = render partial: "new_strategy_form_cells", locals: {strategy: row.strategy}
          yield AnalysisMatricesHelper::Row.new(nil, form, nil)
        elsif row.strategy
          form = render partial: "new_tactic_form_cells", locals: {tactic: row.tactic}
          yield AnalysisMatricesHelper::Row.new(nil, nil, form)
        end
      end

      yield AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)

      first_row = false
    end
  end

  class Row
    attr_reader :objective_cells, :strategy_cells, :tactic_cells
    
    def initialize(objective_cells, strategy_cells, tactic_cells)
      @objective_cells = objective_cells
      @strategy_cells = strategy_cells
      @tactic_cells = tactic_cells
    end
  end
end
