require 'spec_helper'

describe "ExpressionApprovalExpert" do
  before :each do
    @expression = build :objective
    @subject = ExpressionApprovalExpert.new(@expression)
  end

  describe "when verifying if permits role approval" do
    before :each do
      mock_expression_model approval_roles: [0, 1]
    end

    context "returns true" do
      specify 'when the role is included in expression approval roles' do
        expect(@subject.permits_role_approval?(0)).to be == true
        expect(@subject.permits_role_approval?(1)).to be == true
      end

      specify 'when one of the roles is included in expression approval roles' do
        expect(@subject.permits_role_approval?([0, 1])).to be == true
        expect(@subject.permits_role_approval?([0, 2])).to be == true
        expect(@subject.permits_role_approval?([1, 4])).to be == true
      end
    end

    context "returns false" do
      specify "if role id isn't included in expression approval roles" do
        expect(@subject.permits_role_approval?(3)).to be == false
      end

      specify "if all role ids aren't included in expression approval roles" do
        expect(@subject.permits_role_approval?([3, 5])).to be == false
      end
    end
  end

  describe "when verifying if already have needed role approval" do
    context "verifies if all of roles passed that have permission to approve already did it" do
      it "returns true because the unique role passed that have permission already approved" do
        mock_expression_model approval_roles: [0]

        create :approval, expression: @expression, user_role: create(:user_role, role_id: 0)
        
        expect(@subject.already_had_needed_role_approval?([0, 1])).to be == true
      end

      it "returns true because all roles passed have permission and already approved" do
        mock_expression_model approval_roles: [0, 1]

        create :approval, expression: @expression, user_role: create(:user_role, role_id: 0)
        create :approval, expression: @expression, user_role: create(:user_role, role_id: 1)
        
        expect(@subject.already_had_needed_role_approval?([0, 1])).to be == true
      end

      it "returns false because roles passed was an empty array" do
        expect(@subject.already_had_needed_role_approval?([])).to be == false
      end

      it "returns false because any role passed have permission" do
        mock_expression_model approval_roles: [0, 1]
        expect(@subject.already_had_needed_role_approval?([2,3])).to be == false
      end

      it "returns false because the all roles passed have permission and doesn't approved yet" do
        mock_expression_model approval_roles: [0, 1]
        
        expect(@subject.already_had_needed_role_approval?([0, 1])).to be == false
      end

      it "returns false because one of the roles passed have permission and doesn't approved yet" do
        mock_expression_model approval_roles: [0, 1]

        create :approval, expression: @expression, user_role: create(:user_role, role_id: 0)
        
        expect(@subject.already_had_needed_role_approval?([0, 1])).to be == false
      end
    end
  end


  describe "when getting the roles missing approvement" do
    context "gets all approval roles if expression have no approvals yet" do
      it "gets two roles from expression model approval roles" do
        roles_ids = [0, 1]
        mock_expression_model approval_roles: roles_ids

        expect(@subject.roles_missing_approvement).to be == roles_ids
      end
    end

    context "doesn't include roles that already approved that expression" do
      it "ignore two approving roles from expression model approval roles" do
        mock_expression_model approval_roles: [0, 1, 2]

        create :approval, user_role: create(:user_role, role_id: 0), expression: @expression
        create :approval, user_role: create(:user_role, role_id: 1), expression: @expression

        expect(@subject.roles_missing_approvement).to be == [2]
      end
    end
  end

  describe "when getting the roles needed to approve" do
    context "gets all approval roles from expression model" do
      it 'gets two roles because expression model approval have two roles' do
        mock_expression_model approval_roles: [0, 1]

        expect(@subject.roles_needed_to_approve).to be == [0, 1]
      end

      it 'gets two roles even they have approved the expression' do
        mock_expression_model approval_roles: [0, 1]

        create :approval, user_role: create(:user_role, role_id: 0), expression: @expression
        create :approval, user_role: create(:user_role, role_id: 1), expression: @expression

        expect(@subject.roles_needed_to_approve).to be == [0, 1]
      end
    end
  end

  describe "when getting user that approved as a specific role" do
    context "return user if any user approved as the role" do
      it "gets user because he already approved that expression as the role passed" do
        user = create :user
        user_role = create(:user_role, user: user, role_id: 0)
        user.reload

        create :approval, user_role: user_role, expression: @expression

        expect(@subject.user_that_approved_as(0)).to be == user
      end
    end

    context "return nil if none user approved as the role" do
      it "gets nil because nobody approved that expression yet" do
        expect(@subject.user_that_approved_as(0)).to be == nil
      end

      it "gets nil because nobody with the passed role approved that expression" do
        user = create :user
        user_role = create(:user_role, user: user, role_id: 0)
        user.reload

        create :approval, user_role: user_role, expression: @expression

        expect(@subject.user_that_approved_as(1)).to be == nil
      end
    end
  end
end
=begin

spec ExpressionApprovalSpecialist
  @expression

def permits_role_approval?(roles_ids=[])
def already_had_needed_role_approval?(roles_ids=[])
def roles_missing_approvement
def roles_needed_to_approve
def user_that_approved_as(role_id)
  


IMPACT
  Approve button appears?
  What Approvals will be created?


  Approval/Rejection doesn't overrides each other.

=end
