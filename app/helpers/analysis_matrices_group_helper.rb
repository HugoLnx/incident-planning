module AnalysisMatricesGroupHelper
  def approval_checkbox_for_objective?(row)
    checkbox_for_objective?(row) &&
      current_user.can_approve_any_expression_of?(row.objective.objective.group)
  end

  def approval_checkbox_for_strategy?(row)
    checkbox_for_strategy?(row) &&
      current_user.can_approve_any_expression_of?(row.strategy.strategy.group)
  end


  def approval_checkbox_for_tactic?(row)
    checkbox_for_tactic?(row) &&
      current_user.can_approve_any_expression_of?(row.tactic.tactic.group)
  end

  def deletion_checkbox_for_strategy?(row)
    checkbox_for_strategy?(row) &&
      can_create_one_of_same_type_of?(row.strategy.strategy.group)
  end

  def deletion_checkbox_for_tactic?(row)
    checkbox_for_tactic?(row) &&
      can_create_one_of_same_type_of?(row.tactic.tactic.group)
  end

private
  def can_create_one_of_same_type_of?(group)
      group_model = ::Model.find_by_group_name(group.name)
      permission = GroupPermission.new(group_model).to_create?(current_user)
  end

  def checkbox_for_objective?(row)
    row.objective &&
      row.objective.objective &&
      !row.objective.repeated
  end

  def checkbox_for_strategy?(row)
    row.strategy.respond_to?(:strategy) &&
      row.strategy.strategy &&
      !row.strategy.repeated
  end


  def checkbox_for_tactic?(row)
    row.tactic.respond_to?(:tactic) &&
      row.tactic.tactic &&
      !row.tactic.repeated
  end
end
