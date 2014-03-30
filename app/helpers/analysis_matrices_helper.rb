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
    metadata_partial = render_metadata_partial_for(objective.expression)
    render partial: partial, locals: {
      text: text,
      repeated: repeated_class,
      metadata_partial: metadata_partial
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
        metadata_partial: render_metadata_partial_for(expression),
        text: text_from(expression)
      })
    end

    infos
  end

  def render_metadata_partial_for(expression)
    metadata_locals = metadata_locals_from expression

    render partial: "metadata", locals: metadata_locals
  end

  def metadata_locals_from(expression)
    return {
      text: text_from(expression),
      user_permitted_to_approve: check_permitted_to_approve(expression),
      already_approved_by_user: check_already_approved_by_user(expression),
      approval: Approval.new(expression: expression),
      owner_human_id: expression && expression.owner && expression.owner.human_id,
      approvements: approvements_from(expression),
      source: expression && expression.source_name,
      status: expression && expression.status_name,
      expression_id: expression && expression.id
    }
  end

  def approvements_from(expression)
    return [] if expression.nil?
    expression.roles_needed_to_approve.map do |role|
      user = expression.user_that_approved_as role
      {
        user_human_id: user && user.human_id,
        role: ::Roles::Dao.new.find_by_id(role).name
      }
    end
  end

  def text_from(expression)
    expression && expression.info_as_str
  end

  def check_permitted_to_approve(expression)
    expression && expression.permits_role_approval?(current_user.roles_ids)
  end

  def check_already_approved_by_user(expression)
    expression && expression.already_had_needed_role_approval?(current_user.roles_ids)
  end

  def get_proc(helper_name)
    method(helper_name).to_proc
  end
end
