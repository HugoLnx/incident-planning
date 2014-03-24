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
      expression_model = build :expression, approval_roles: [0, 1]
      allow(Model).to receive(:find_expression_by_name).and_return(expression_model)
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
end
