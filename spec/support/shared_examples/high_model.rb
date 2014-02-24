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
end
