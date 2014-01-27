module AnalysisMatricesHelper
  def each_row(matrix_data, &block)
    first_row = true

    last_row = nil
    matrix_data.each_row do |row|
      objective_cells = render_objective_cells(row.objective, row.objective_repeated)
      strategy_cells = render_strategy_cells(row.strategy, row.strategy_repeated)
      tactic_cells = render_tactic_cells(row.tactic, row.tactic_repeated)

      unless first_row
        yield_form_for_row(row, last_row, &block)
      end

      yield AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)

      first_row = false
      last_row = row
    end

    #yield_form_for_row(last_row, &block)
  end

  def yield_form_for_row(row, prev_row, &block)
    strategy_form = nil
    tactic_form = nil

    if !row.strategy_repeated
      form = render partial: "new_tactic_form_cells", locals: {tactic: row.tactic}
      objective_cells = render_objective_cells(prev_row.objective, true)
      strategy_cells = render_strategy_cells(prev_row.strategy, true)
      yield AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, form)
    end

    if !row.objective_repeated
      form = render partial: "new_strategy_form_cells", locals: {strategy: prev_row.strategy}
      objective_cells = render_objective_cells(prev_row.objective, true)
      yield AnalysisMatricesHelper::Row.new(objective_cells, form, render_tactic_cells)
    end
  end

  def render_objective_cells(objective = nil, repeated = false)
    render partial: "objective_cells", locals: {objective: objective, repeated: repeated}
  end

  def render_strategy_cells(strategy = nil, repeated = false)
    render partial: "strategy_cells", locals: {strategy: strategy, repeated: repeated}
  end

  def render_tactic_cells(tactic = nil, repeated = false)
    render partial: "tactic_cells", locals: {tactic: tactic, repeated: repeated}
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
