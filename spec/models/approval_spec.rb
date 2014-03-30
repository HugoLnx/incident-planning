require 'spec_helper'

describe Approval do
  describe "the class" do
    describe "when user approve expression" do
      context "initialize an approval to each needed role of user" do
        it "initialize nothing because user haven't roles matching expression needed roles" do
          user = create :user
          create :user_role, user: user, role_id: 0
          create :user_role, user: user, role_id: 1

          expression = create :objective
          mock_expression_model approval_roles: [2, 3, 4]

          approvals = Approval.build_all_to(user, approve: expression)
          expect(approvals).to be_empty
        end

        it "initialize two approvals because two user roles are exactly the expression needed roles" do
          user = create :user
          create(:user_role, user: user, role_id: 0)
          create(:user_role, user: user, role_id: 1)
          user.reload

          expression = create :objective
          mock_expression_model approval_roles: [0, 1]

          approvals = Approval.build_all_to(user, approve: expression)

          approved_user_roles = approvals.map(&:user_role)
          expect(approved_user_roles).to include user.user_roles[0]
          expect(approved_user_roles).to include user.user_roles[1]
          expect(approvals[0].user_role.user).to be == user
          expect(approvals[1].user_role.user).to be == user
          expect(approvals[0].expression).to be == expression
          expect(approvals[1].expression).to be == expression
          expect(approvals.size).to be == 2
        end

        it "initialize two approvals because two expression needed roles match with user roles" do
          user = create :user
          create(:user_role, user: user, role_id: 1)
          create(:user_role, user: user, role_id: 2)
          user.reload

          expression = create :objective
          mock_expression_model approval_roles: [0, 1, 2, 3]

          approvals = Approval.build_all_to(user, approve: expression)

          approved_user_roles = approvals.map(&:user_role)
          expect(approved_user_roles).to include user.user_roles[0]
          expect(approved_user_roles).to include user.user_roles[1]
          expect(approvals[0].user_role.user).to be == user
          expect(approvals[1].user_role.user).to be == user
          expect(approvals[0].expression).to be == expression
          expect(approvals[1].expression).to be == expression
          expect(approvals.size).to be == 2
        end
      end
    end
  end
end
