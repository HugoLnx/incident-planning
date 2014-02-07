shared_examples_for "Expression" do
  let(:model) {described_class}

  context "when initializing a new objective" do
    it "sets his name properly" do
      objective = model.new_objective
      expect(objective.name).to be == Model.objective.name
    end
  end

  context "when initializing a new strategy" do
    it "sets his name properly" do
      strategy = model.new_strategy
      expect(strategy.name).to be == Model.strategy.name
    end
  end
end
