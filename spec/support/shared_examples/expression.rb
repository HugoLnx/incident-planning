shared_examples_for "Expression" do
  let(:model) {described_class}

  context "when initializing a new objective" do
    it "sets his name properly" do
      objective = model.new_objective
      expect(objective.name).to be == Model.objective.name
    end
  end

  context "when initializing a new expression" do
    it 'sets source to zero (Proposed)' do
      expression = model.new
      expect(expression.source).to be == Concerns::Expression::SOURCES.proposed()
    end
  end
end
