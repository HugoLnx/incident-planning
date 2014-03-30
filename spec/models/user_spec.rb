require 'spec_helper'

describe User do
  let(:inexistent_role_id){999999}

  context "when setting the roles by it's ids" do
    context "receiving 2 ids and have no other roles" do
      it 'create 2 user roles' do
        user = create :user, roles_ids: %w{0 1 2}

        expect(user.user_roles[0].role_id).to be == 0
        expect(user.user_roles[1].role_id).to be == 1
        expect(user.user_roles[2].role_id).to be == 2
        
        expect(user.user_roles[0].user_id).to be == user.id
        expect(user.user_roles[1].user_id).to be == user.id
        expect(user.user_roles[2].user_id).to be == user.id
      end
    end

    context "receiving 2 ids and have 3 other roles" do
      before :each do
        @original_roles = build_list(:user_role, 3)
        @user = create :user, user_roles: @original_roles
        @user.roles_ids = %w{3 3}
      end

      it 'update first 2 user roles' do
        expect(@user.user_roles[0].role_id).to be == 3
        expect(@user.user_roles[1].role_id).to be == 3
      end

      it 'maintain the first 2 user roles' do
        expect(@user.user_roles.to_a).to be == @original_roles.first(2)
      end

      it 'destroy the last role' do
        expect(@original_roles.last).to be_destroyed
      end
    end
  end

  context "when getting the roles ids" do
    it "gets id of all user roles" do
      user = create :user, user_roles: build_list(:user_role, 3)

      ids = user.roles_ids
      expect(ids[0]).to be == user.user_roles[0].role_id
      expect(ids[1]).to be == user.user_roles[1].role_id
      expect(ids[2]).to be == user.user_roles[2].role_id
    end
  end

  describe "validations" do
    context "when one of its roles is invalid" do
      it 'will be invalid' do
        user = build :user, roles_ids: [inexistent_role_id]
        expect(user).to_not be_valid
      end
    end
  end

  describe "when getting an specific user role" do
    before :each do
      user = create :user
      @user_roles = 3.times.map do |i|
        create :user_role, user: user, role_id: i
      end
      @user = User.includes(:user_roles).find user.id
    end

    context "find the user roles by role id" do
      it "find the first user role" do
        expect(@user.user_role(0)).to be == @user_roles[0]
      end

      it "find a middle one user role" do
        expect(@user.user_role(1)).to be == @user_roles[1]
      end

      it "find the last user role" do
        expect(@user.user_role(2)).to be == @user_roles[2]
      end
    end
  end
end
