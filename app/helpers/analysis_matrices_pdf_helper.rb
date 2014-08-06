module AnalysisMatricesPdfHelper
  LINES_PER_BLOCK = 10
  def pdf_each_block(matrix_data, &block)
    rows = AnalysisMatrixRendererContainer::RowsIterator.new(matrix_data, callbacks: {
      show_objective: get_proc(:render_objective_text),
      show_strategy: get_proc(:render_strategy_text),
      show_tactic: get_proc(:render_tactic_text)
    }).rows

    while !rows.empty?
      yield rows.pop(LINES_PER_BLOCK)
    end
  end

  def render_objective_text(objective, repeated, last_child, last_repetition)
    if !repeated && objective
      expression = objective.expression
      expression && expression.info_as_str
    end
  end

  def render_strategy_text(strategy, repeated, last_child, last_repetition, blank)
    if !repeated && strategy
      expression = strategy.how
      expression && expression.info_as_str
    end
  end

  def render_tactic_text(tactic, repeated, last_child, last_repetition, blank)
    if !repeated && tactic
      [
        tactic.who && tactic.who.info_as_str,
        tactic.what && tactic.what.info_as_str,
        tactic.where && tactic.where.info_as_str,
        tactic.when && tactic.when.info_as_str
      ].join(", ")
    end
  end
end
