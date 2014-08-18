class GroupPermission
  def initialize(group_model)
    @group_model = group_model
  end

  def to_create?(user)
    can_create = !(user.roles_ids & @group_model.creator_roles).empty?
    !user.features_config.authority_control? || can_create
  end

  alias to_update? to_create?
end
