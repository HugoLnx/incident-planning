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
    text = text_from objective.expression
    repeated_class = repeated_class(repeated)
    metadata = metadata_from(objective.expression)
    render partial: partial, locals: {
      text: text,
      repeated: repeated_class,
      metadata: metadata,
      can_approve: check_can_approve(objective.expression)
    }
  end

  def render_show_strategy_cells(strategy, repeated)
    partial = "strategy_cells"
    infos = show_cells_info_from(strategy, ::Model.strategy)
    repeated_class = repeated_class(repeated)

    update_path = strategy && incident_cycle_strategy_path(@incident, @cycle, strategy.group_id)
    delete_path = update_path

    render partial: partial, locals: {
      expressions: infos,
      repeated: repeated_class,
      update_path: update_path,
      delete_path: delete_path
    }
  end

  def render_new_strategy_cells(father_id)
    partial = "new_strategy_form_cells"
    expressions_size = ::Model.strategy.expressions.size
    render partial: partial, locals: {
      father_id: father_id,
      expressions_size: expressions_size
    }
  end

  def render_show_tactic_cells(tactic, repeated)
    partial = "tactic_cells"

    update_path = tactic && incident_cycle_tactic_path(@incident, @cycle, tactic.group_id)
    delete_path = update_path

    infos = show_cells_info_from(tactic, ::Model.tactic)
    repeated_class = repeated_class(repeated)

    render partial: partial, locals: {
      expressions: infos,
      repeated: repeated_class,
      update_path: update_path,
      delete_path: delete_path
    }
  end

  def render_new_tactic_cells(father_id)
    partial = "new_tactic_form_cells"
    expressions_size = ::Model.tactic.expressions.size
    render partial: partial, locals: {
      father_id: father_id,
      expressions_size: expressions_size
    }
  end

  def repeated_class(is_repeated)
    is_repeated ? "repeated" : "non-repeated"
  end

private

  def show_cells_info_from(group, model)
    infos = {}

    model.expressions.each do |expression_model|
      name = expression_model.pretty_name
      expression = group && group.public_send(name)
      infos.merge!(name => {
        metadata: metadata_from(expression),
        text: text_from(expression),
        can_approve: check_can_approve(expression)
      })
    end

    infos
  end

  def metadata_from(expression)
    return {
      owner_email: expression && expression.owner && expression.owner.email,
      source: expression && expression.source_name,
      status: expression && expression.status_name
    }
  end

  def text_from(expression)
    expression && expression.info_as_str
  end

  def check_can_approve(expression)
    expression && expression.needs_role_approval?(current_user.roles_ids)
  end

  def get_proc(helper_name)
    method(helper_name).to_proc
  end
end
