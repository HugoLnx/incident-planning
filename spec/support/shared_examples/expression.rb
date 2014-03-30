shared_examples_for "Expression" do
  let(:model) {described_class}

  context "when initializing a new objective" do
    it "sets his name properly" do
      objective = model.new_objective
      expect(objective.name).to be == Model.objective.name
    end
  end

  context "when verifying if needs role approval" do
    before :each do
      mock_expression_model approval_roles: [0, 1]
      @expression = build :text_expression
    end

    context "returns true" do
      specify 'when the role is included in expression approval roles' do
        expect(@expression.needs_role_approval?(0)).to be true
        expect(@expression.needs_role_approval?(1)).to be true
      end

      specify 'when one of the roles is included in expression approval roles' do
        expect(@expression.needs_role_approval?([0, 1])).to be true
        expect(@expression.needs_role_approval?([0, 2])).to be true
        expect(@expression.needs_role_approval?([1, 4])).to be true
      end
    end

    context "returns false" do
      specify "if role id isn't included in expression approval roles" do
        expect(@expression.needs_role_approval?(3)).to be false
      end

      specify "if all role ids aren't included in expression approval roles" do
        expect(@expression.needs_role_approval?([3, 5])).to be false
      end
    end
  end

  context "when initializing a new expression" do
    it 'sets source to zero (Proposed)' do
      expression = model.new
      expect(expression.source).to be == Concerns::Expression::SOURCES.proposed()
    end
  end

  describe "when getting the roles missing to approval" do
    context "gets all approval roles if expression have no approvals yet" do
      it "gets two roles from expression model approval roles" do
        roles_ids = [0, 1]
        mock_expression_model approval_roles: roles_ids
        expression = build :text_expression

        expect(expression.roles_needing_to_approve).to be == roles_ids
      end
    end

    context "doesn't include roles that already approved that expression" do
      it "ignore two approving roles from expression model approval roles" do
        mock_expression_model approval_roles: [0, 1, 2]
        expression = create :objective

        create :approval, user_role: create(:user_role, role_id: 0), expression: expression
        create :approval, user_role: create(:user_role, role_id: 1), expression: expression

        expect(expression.roles_needing_to_approve).to be == [2]
      end
    end
  end
end
