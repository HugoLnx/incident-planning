module AnalysisMatricesHelper
  def each_row(matrix_data, &block)
    AnalysisMatrixRendererContainer::RowsIterator.new(matrix_data, callbacks: {
      show_objective: get_proc(:render_show_objective_cells),
      show_strategy: get_proc(:render_show_strategy_cells),
      show_tactic: get_proc(:render_show_tactic_cells),
      new_strategy: get_proc(:render_new_strategy_cells),
      new_tactic: get_proc(:render_new_tactic_cells)
    }).each_row(&block)
  end

  def render_show_objective_cells(objective, repeated)
    partial = "objective_cells"
    text = objective && objective.expression && objective.expression.text
    repeated_class = repeated ? "repeated" : "non-repeated"
    render partial: partial, locals: {text: text, repeated: repeated_class}
  end

  def render_show_strategy_cells(strategy, repeated)
    partial = "strategy_cells"
    texts = {
      how: strategy && strategy.how && strategy.how.text,
      why: strategy && strategy.why && strategy.why.text
    }
    repeated_class = repeated ? "repeated" : "non-repeated"
    render partial: partial, locals: {texts: texts, repeated: repeated_class}
  end

  def render_new_strategy_cells(father_id)
    partial = "new_strategy_form_cells"
    render partial: partial, locals: {father_id: father_id}
  end

  def render_show_tactic_cells(tactic, repeated)
    partial = "tactic_cells"

    texts = {
      who:   tactic && tactic.who   && tactic.who.text,
      what:  tactic && tactic.what  && tactic.what.text,
      where: tactic && tactic.where && tactic.where.text,
      when:  tactic && tactic.when  && tactic.when.time,
      response_action: tactic && tactic.response_action && tactic.response_action.text
    }
    repeated_class = repeated ? "repeated" : ""
    render partial: partial, locals: {texts: texts, repeated: repeated_class}
  end

  def render_new_tactic_cells(father_id)
    partial = "new_tactic_form_cells"
    render partial: partial, locals: {father_id: father_id}
  end

private
  def get_proc(helper_name)
    method(helper_name).to_proc
  end
end
