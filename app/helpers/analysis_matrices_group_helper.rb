module AnalysisMatricesGroupHelper
  def checkbox_for_objective?(row)
    row.objective &&
      row.objective.objective &&
      !row.objective.repeated &&
      current_user.can_approve_any_expression_of?(row.objective.objective.group)
  end

  def checkbox_for_strategy?(row)
    row.strategy.respond_to?(:strategy) &&
      row.strategy.strategy &&
      !row.strategy.repeated &&
      current_user.can_approve_any_expression_of?(row.strategy.strategy.group)
  end


  def checkbox_for_tactic?(row)
    row.tactic.respond_to?(:tactic) &&
      row.tactic.tactic &&
      !row.tactic.repeated &&
      current_user.can_approve_any_expression_of?(row.tactic.tactic.group)
  end
end
