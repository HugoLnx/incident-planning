class Approval < ActiveRecord::Base
  belongs_to :expression, polymorphic: true
  belongs_to :user_role


  def self.build_all_to(user, positive: nil, approve: nil)
    expression = approve || raise(ArgumentError.new, "approving parameter is mandatory")

    roles_user_can_approve = user.roles_ids & expression.roles_missing_approvement

    roles_user_can_approve.map do |role_id|
      approving_user_role = user.user_role(role_id)
      Approval.new(
        user_role: approving_user_role,
        expression: expression,
        positive: positive
      )
    end
  end
end
