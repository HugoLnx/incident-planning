module AnalysisMatricesHelper
  RESOURCE_NAME = "Work Analysis Matrix (ICS 234)"
  CRITICALITY_CLASSES = {"H" => "high", "M" => "medium", "L" => "low"}

  def analysis_matrix_resource_name
    RESOURCE_NAME
  end

  def each_row(matrix_data, &block)
    AnalysisMatrixRendererContainer::RowsIterator.new(matrix_data, callbacks: {
      show_objective: get_proc(:render_show_objective_cells),
      show_strategy: get_proc(:render_show_strategy_cells),
      show_tactic: get_proc(:render_show_tactic_cells),
      new_strategy: get_proc(:render_new_strategy_cells),
      new_tactic: get_proc(:render_new_tactic_cells)
    }).each_row(&block)
  end

  def each_row_for_group_approval(matrix_data, &block)
    AnalysisMatrixRendererContainer::RowsIterator.new(matrix_data, callbacks: {
      show_objective: get_proc(:render_show_objective_cells),
      show_strategy: get_proc(:render_show_strategy_cells),
      show_tactic: get_proc(:render_show_tactic_cells)
    }).each_row(&block)
  end

  def render_show_objective_cells(objective, repeated, last_child, last_repetition)
    partial = "analysis_matrices/objective_cells.html.erb"
    locals = cells_generic_locals_from(
      objective.expression,
      repeated,
      last_child,
      last_repetition
    )
    locals.merge!(show_cells_info_from(objective, ::Model.root, false, repeated)["objective"])
    locals[:number] = objective.expression && objective.expression.number

    render partial: partial,
      locals: locals
  end

  def render_show_strategy_cells(strategy, repeated, last_child, last_repetition, blank)
    partial = "analysis_matrices/strategy_cells.html.erb"
    locals = cells_generic_locals_from(
      strategy,
      repeated,
      last_child,
      last_repetition,
      ::Model.strategy,
      blank
    )

    update_path = strategy && incident_cycle_strategy_path(@incident, @cycle, strategy.group_id)
    delete_path = update_path

    infos = show_cells_info_from(strategy, ::Model.strategy, blank, repeated)

    locals[:expressions] = infos
    locals[:update_path] = update_path
    locals[:delete_path] = delete_path
    render partial: partial,
      locals: locals
  end

  def render_new_strategy_cells(father_id)
    partial = "analysis_matrices/new_strategy_form_cells.html.erb"
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
    partial = "analysis_matrices/tactic_cells.html.erb"

    locals = cells_generic_locals_from(
      tactic,
      repeated,
      last_child,
      last_repetition,
      ::Model.tactic,
      blank
    )

    update_path = tactic && incident_cycle_tactic_path(@incident, @cycle, tactic.group_id)
    delete_path = update_path

    infos = show_cells_info_from(tactic, ::Model.tactic, blank, repeated)

    locals[:expressions] = infos
    locals[:update_path] = update_path
    locals[:delete_path] = delete_path

    locals[:group] = tactic && tactic.group
    if locals[:group]
      locals[:criticality_level] = CRITICALITY_CLASSES[locals[:group].criticality]
    else
      locals[:criticality_level] = nil
    end
    render partial: partial,
      locals: locals
  end

  def render_new_tactic_cells(father_id)
    partial = "analysis_matrices/new_tactic_form_cells.html.erb"
    tactic_model = ::Model.tactic
    expressions_size = tactic_model.expressions.size
    permission = GroupPermission.new(tactic_model)
    render partial: partial, locals: {
      father_id: father_id,
      expressions_size: expressions_size,
      disabled: !permission.to_create?(current_user)
    }
  end

  def editable_class(repeated, model)
    if model.nil?
      editable = false
    else
      permission = GroupPermission.new(model)
      editable = !repeated && permission.to_update?(current_user)
    end
    editable ? "editable" : "non-editable"
  end

  def type_class(repeated, blank=false)
    return "blank" if blank
    repeated ? "repeated" : "non-repeated"
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

  def show_delete_in_group_button?
    permissions = [
      GroupPermission.new(::Model.strategy),
      GroupPermission.new(::Model.tactic)
    ]
    permissions.any?{|permission| permission.to_create? current_user}
  end

  def show_approval_in_group_button?
    permissions = [
      GroupPermission.new(::Model.root),
      GroupPermission.new(::Model.strategy),
      GroupPermission.new(::Model.tactic)
    ]
    current_user.features_config.traceability? && 
      permissions.any?{|permission| permission.to_create? current_user}
  end

  def can_edit_tactic?
    permission = GroupPermission.new(::Model.tactic)
    permission.to_update?(current_user)
  end

  def must_cache_strategy?(row)
    row.strategy_cells.cells.is_a?(AnalysisMatrixRendererContainer::StrategyCells::Show)
  end

  def must_cache_tactic?(row)
    row.tactic_cells.cells &&
      row.tactic_cells.cells.is_a?(AnalysisMatrixRendererContainer::TacticCells::Show) &&
      row.tactic_cells.cells.tactic
  end

  def objective_cache_key(row)
    cells = row.objective_cells.cells
    args = cells.callback_args + [current_user.features_config.thesis_tools?]
    [args, cells.objective.group]
  end

  def strategy_cache_key(row)
    return "matrix-cache-strategy-must-not-cache" unless must_cache_strategy?(row)
    cells = row.strategy_cells.cells
    args = cells.callback_args + [current_user.features_config.thesis_tools?]
    [args, cells.strategy.group]
  end

  def tactic_cache_key(row)
    return "matrix-cache-tactic-must-not-cache" unless must_cache_tactic?(row)
    cells = row.tactic_cells.cells
    args = cells.callback_args + [current_user.features_config.thesis_tools?]
    [args, cells.tactic.group]
  end

  def criticalities_collection
    Group::CRITICALITY_NAMES.map do |value, name|
      ["#{value} #{name}", value]
    end
  end

  def row_classes(row)
    classes = ["have-objective"]
    cells = row.strategy_cells.cells
    if cells.is_a?(AnalysisMatrixRendererContainer::StrategyCells::Show) && !cells.blank
      classes << "have-strategy"
    end
    cells = row.tactic_cells.cells
    if cells.is_a?(AnalysisMatrixRendererContainer::TacticCells::Show) && !cells.blank
      classes << "have-tactic"
    end
    classes.join " "
  end

  def matrix_classes
    classes = []
    if current_user.features_config.thesis_tools?
      classes << "thesis-on"
    else
      classes << "thesis-off"
    end

    if current_user.reuse_configuration.reuse_hierarchy?
      classes << "reuse-hierarchy-on"
    else
      classes << "reuse-hierarchy-off"
    end
    classes.join " "
  end

private

  def serialize_args(args)
    args[1..-1].join("-")
  end

  def show_cells_info_from(group, model, blank, repeated)
    infos = {}

    model.expressions.each do |expression_model|
      name = expression_model.pretty_name
      expression = group && group.public_send(name)
      infos.merge!(name => {
        metadata_partial: render_metadata_partial_for(expression, blank, repeated),
        text: text_from(expression)
      })
      infos[name][:exp_classes] = classes_for(expression)
      infos[name][:expression_id] = expression && expression.id
      infos[name][:can_approve_expression] = expression && current_user.can_approve_expression?(expression)
    end

    infos
  end
  
  def classes_for(expression)
    classes = [
      status_class(expression),
      reused_class(expression),
      error_class(expression)
    ]
    classes += group_error_classes(expression)
    classes.join(" ")
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
    return (expression.reused? ? "reused" : "non-reused")
  end
  
  def error_class(expression)
    return "" if expression.nil? || @expression_errors.nil?
    if (
      expression.is_a?(TextExpression) &&
      @expression_errors[:text].has_key?(expression.id)
    ) || (
      expression.is_a?(TimeExpression) &&
      @expression_errors[:time].has_key?(expression.id)
    )
      return "with-errors"
    else
      "no-errors"
    end
  end

  def errors_from(expression)
    return [] if expression.nil?

    errors = []
    if @expression_errors
      if expression.is_a? TextExpression
        errors += @expression_errors[:text][expression.id]
      else
        errors += @expression_errors[:time][expression.id]
      end
    end

    if @group_errors
      errors += @group_errors.on(expression.id)
    end

    errors
  end

  def group_error_classes(expression)
    return [] if expression.nil? || @group_errors.nil?

    return ["no-group-errors"] unless @group_errors.include? expression.id

    @group_errors.mark_for_group(expression.id, expression.group_id)

    classes = ["with-group-errors"]
    if @group_errors.one_marked_on_group?(expression.id, expression.group_id)
      classes << "first-in-group-error"
    elsif @group_errors.all_marked_on_group?(expression.id, expression.group_id)
      classes << "last-in-group-error"
    else
      classes << "middle-in-group-error"
    end

    classes
  end

  def render_metadata_partial_for(expression, blank, repeated)
    if blank || repeated
      return ""
    else
      metadata_locals = metadata_locals_from expression

      render partial: "analysis_matrices/metadata.html.erb", locals: metadata_locals
    end
  end

  def metadata_locals_from(expression)
    return {
      text: text_from(expression),
      user_permitted_to_approve: check_permitted_to_approve(expression),
      already_approved_by_user: check_already_approved_by_user(expression),
      approval: Approval.new(expression: expression),
      owner_human_id: expression && expression.owner && expression.owner.human_id,
      owner: expression && expression.owner,
      approvals_infos: approvals_infos_from(expression),
      source: expression && expression.source_name,
      status: expression && expression.status_name,
      errors: errors_from(expression),
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
        positive: approval && approval.positive,
        user: user
      }
    end
  end

  def cells_generic_locals_from(expression, repeated, last_child, last_repetition, model=nil, blank=false)
    type_class = type_class(repeated, blank)
    last_child_class = last_child_class(last_child)
    last_repetition_class = last_repetition_class(last_repetition)
    editable_class = editable_class(repeated, model)

    locals = {
      group_classes: [
        type_class,
        last_child_class,
        last_repetition_class,
        editable_class
      ].join(" ")
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
