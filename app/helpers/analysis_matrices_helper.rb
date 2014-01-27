module AnalysisMatricesHelper
  def each_row(matrix_data, &block)
    first_row = true

    last_row = nil
    matrix_data.each_row do |row|
      objective_cells = render_objective_cells(row.objective, row.has_objective_repeated?)
      if row.strategy.nil?
        strategy_cells = render partial: "new_strategy_form_cells"
      else
        strategy_cells = render_strategy_cells(row.strategy, row.has_strategy_repeated?)
      end

      if row.strategy && row.tactic.nil?
        tactic_cells = render partial: "new_tactic_form_cells"
      else
        tactic_cells = render_tactic_cells(row.tactic, row.has_tactic_repeated?)
      end

      unless first_row
        yield_extra_rows_with_forms(last_row, row, &block)
      end

      yield AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, tactic_cells)

      first_row = false
      last_row = row
    end

    yield_extra_rows_with_forms(last_row, &block)
  end

  def yield_extra_rows_with_forms(prev_row, row=nil, &block)
    strategy_form = nil
    tactic_form = nil

    if prev_row.tactic && (row.nil? || !row.has_strategy_repeated?)
      form = render partial: "new_tactic_form_cells"
      objective_cells = render_objective_cells(prev_row.objective, true)
      strategy_cells = render_strategy_cells(prev_row.strategy, true)
      yield AnalysisMatricesHelper::Row.new(objective_cells, strategy_cells, form)
    end

    if prev_row.strategy && (row.nil? || !row.has_objective_repeated?)
      form = render partial: "new_strategy_form_cells"
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
