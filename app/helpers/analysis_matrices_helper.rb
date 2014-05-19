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

  def render_show_objective_cells(objective, repeated, last_child, last_repetition)
    partial = "objective_cells"
    locals = cells_generic_locals_from(objective.expression, repeated, last_child, last_repetition)
    locals.merge!(show_cells_info_from(objective, ::Model.root)["objective"])

    render partial: partial,
      locals: locals
  end

  def render_show_strategy_cells(strategy, repeated, last_child, last_repetition)
    partial = "strategy_cells"
    locals = cells_generic_locals_from(strategy, repeated, last_child, last_repetition)

    infos = show_cells_info_from(strategy, ::Model.strategy)
    permission = GroupPermission.new(::Model.strategy)
    editable = !repeated && permission.to_update?(current_user)

    update_path = strategy && incident_cycle_strategy_path(@incident, @cycle, strategy.group_id)
    delete_path = update_path

    locals[:expressions] = infos
    locals[:update_path] = update_path
    locals[:delete_path] = delete_path
    locals[:editable] = editable
    render partial: partial,
      locals: locals
  end

  def render_new_strategy_cells(father_id)
    partial = "new_strategy_form_cells"
    strategy_model = ::Model.strategy
    expressions_size = strategy_model.expressions.size
    permission = GroupPermission.new(strategy_model)
    render partial: partial, locals: {
      father_id: father_id,
      expressions_size: expressions_size,
      disabled: !permission.to_create?(current_user)
    }
  end

  def render_show_tactic_cells(tactic, repeated, last_child, last_repetition, blank)
    partial = "tactic_cells"

    locals = cells_generic_locals_from(tactic, repeated, last_child, last_repetition, blank)

    update_path = tactic && incident_cycle_tactic_path(@incident, @cycle, tactic.group_id)
    delete_path = update_path

    infos = show_cells_info_from(tactic, ::Model.tactic)
    permission = GroupPermission.new(::Model.tactic)
    editable = !repeated && permission.to_update?(current_user)

    locals[:expressions] = infos
    locals[:update_path] = update_path
    locals[:delete_path] = delete_path
    locals[:editable] = editable

    render partial: partial,
      locals: locals
  end

  def render_new_tactic_cells(father_id)
    partial = "new_tactic_form_cells"
    tactic_model = ::Model.tactic
    expressions_size = tactic_model.expressions.size
    permission = GroupPermission.new(tactic_model)
    render partial: partial, locals: {
      father_id: father_id,
      expressions_size: expressions_size,
      disabled: !permission.to_create?(current_user)
    }
  end

  def type_class(is_repeated, is_blank=false)
    return "blank" if is_blank
    is_repeated ? "repeated" : "non-repeated"
  end

  def last_child_class(is_last_child)
    is_last_child ? "last-child" : "non-last-child"
  end

  def last_repetition_class(is_last_repetition)
    is_last_repetition ? "last-repetition" : "non-last-repetition"
  end

  def approval_class(positive)
    positive ? "approved" : "rejected"
  end

  def approval_text(positive)
    positive ? "Approved" : "Rejected"
  end

  def editable_class(editable)
    editable ? "editable" : "non-editable"
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
      infos[name][:status_class] = status_class(expression)
      infos[name][:reused_class] = reused_class(expression)
    end

    infos
  end

  def status_class(expression)
    return "" if expression.nil?
    case expression.status
    when Concerns::Expression::STATUS.to_be_approved
      return "to-be-approved"
    when Concerns::Expression::STATUS.partial_approval
      return "partial-approval"
    when Concerns::Expression::STATUS.approved
      return "approved"
    when Concerns::Expression::STATUS.partial_rejection
      return "partial-rejection"
    when Concerns::Expression::STATUS.rejected
      return "rejected"
    end
  end

  def reused_class(expression)
    return "" if expression.nil?
    if expression.reused_expression.nil?
      return "non-reused"
    else
      return "reused"
    end
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
      approvals_infos: approvals_infos_from(expression),
      source: expression && expression.source_name,
      status: expression && expression.status_name,
      expression_id: expression && expression.id
    }
  end

  def approvals_infos_from(expression)
    return [] if expression.nil?
    approval_expert = ExpressionApprovalExpert.new(expression)
    expression.roles_needed_to_approve.map do |needed_role|
      approval = approval_expert.approval_made_by_role(needed_role)
      user = approval && approval.user
      {
        user_human_id: user && user.human_id,
        role: ::Roles::Dao.new.find_by_id(needed_role).name,
        positive: approval && approval.positive
      }
    end
  end

  def cells_generic_locals_from(expression, repeated, last_child, last_repetition, blank=false)
    type_class = type_class(repeated)
    last_child_class = last_child_class(last_child)
    last_repetition_class = last_repetition_class(last_repetition)

    locals = {
      type_class: type_class,
      last_child_class: last_child_class,
      last_repetition_class: last_repetition_class,
    }

    locals
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
