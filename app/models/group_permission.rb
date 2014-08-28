class GroupPermission
  def initialize(group_model)
    @group_model = group_model
  end

  def to_approve?(user)
    @group_model.expressions.all? do |exp|
      can_approve = !(user.roles_ids & exp.approval_roles).empty?
      can_approve
    end
  end

  def to_create?(user)
    can_create = !(user.roles_ids & @group_model.creator_roles).empty?
    !user.features_config.authority_control? || can_create
  end

  alias to_update? to_create?
end
