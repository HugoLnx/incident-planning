class ExpressionApprovalExpert
  def initialize(expression)
    @expression = expression
  end

  def permits_role_approval?(roles_ids=[])
    if roles_ids.is_a? Fixnum
      roles_ids = [roles_ids]
    end
    !(roles_needed_to_approve & roles_ids).empty?
  end

  def already_had_needed_role_approval?(roles_ids=[])
    permitted_roles = roles_ids & roles_needed_to_approve
    return false if permitted_roles.empty?

    approving_roles = @expression.approvals.map{|a| a.role_id}
    (permitted_roles - approving_roles).empty?
  end

  def roles_missing_approvement
    approving_roles = @expression.approvals.map{|a| a.role_id}
    roles_needed_to_approve - approving_roles
  end

  def roles_needed_to_approve
    @expression.expression_model.approval_roles
  end

  def approval_made_by_role(role_id)
    @expression.approvals.find{|approval| approval.role_id == role_id}
  end
end
