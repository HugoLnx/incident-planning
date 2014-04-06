class GroupPermission
  def initialize(group_model)
    @group_model = group_model
  end

  def to_create?(user)
    !(user.roles_ids & @group_model.creator_roles).empty?
  end

  alias to_update? to_create?
end
