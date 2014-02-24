shared_examples "High Model" do
  it_behaves_like "ActiveModel"

  context "when updating" do
    before :each do
      allow(subject).to receive(:update_how)
      allow(subject).to receive(:update_what)
      subject.update how: "text1", what: "text2"
    end

    it "call the update method to each attribute" do
      expect(subject).to have_received(:update_how).with("text1")
      expect(subject).to have_received(:update_what).with("text2")
    end
  end

  describe "when set from a group" do
    before :each do
      @model = described_class.new

      @how = build(:text_expression, name: "how")
      @who = build(:text_expression, name: "who")

      @group = create :group,
        text_expressions: [@how, @who],
        father: create(:group)

      @model.set_from_group @group
    end

    it "sets group" do
      expect(@group).to be == @model.group
    end

    it "sets cycle_id to the one of the group" do
      expect(@model.cycle_id).to be == @group.cycle_id
    end

    it "sets father_id to the one of the group" do
      expect(@model.father_id).to be == @group.father_id
    end

    it "the reference of text_expressions is replaced by the ones in group" do
      expect(@model.instance_variable_get(:@how)).to be == @how
      expect(@model.instance_variable_get(:@who)).to be == @who
    end
  end
end
