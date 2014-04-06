require 'spec_helper'

describe GroupPermission do
  context "when checking if can create" do
    context "verify if user have a role in group model creator roles" do
      it "allow because user have all three group model creator roles" do
        group_model = build :model_group, creator_roles: [2, 3, 4]
        user = create :user
        create :user_role, user: user, role_id: 2
        create :user_role, user: user, role_id: 3
        create :user_role, user: user, role_id: 4
        user.reload

        permission = GroupPermission.new(group_model)
        expect(permission.to_create?(user)).to be true
      end

      it "allow because user have one of three group model creator roles" do
        group_model = build :model_group, creator_roles: [2, 3, 4]
        user = create :user
        create :user_role, user: user, role_id: 2
        user.reload

        permission = GroupPermission.new(group_model)
        expect(permission.to_create?(user)).to be true
      end

      it "does not allow because user haven't any role" do
        group_model = build :model_group, creator_roles: [2, 3, 4]
        user = create :user

        permission = GroupPermission.new(group_model)
        expect(permission.to_create?(user)).to be false
      end

      it "does not allow because user have two roles that are diferent from the three group model creator roles" do
        group_model = build :model_group, creator_roles: [2, 3, 4]
        user = create :user
        create :user_role, user: user, role_id: 0
        create :user_role, user: user, role_id: 1
        user.reload

        permission = GroupPermission.new(group_model)
        expect(permission.to_create?(user)).to be false
      end
    end
  end
end
