shared_examples "High Model" do
  it_behaves_like "ActiveModel"

  describe "when saving" do
    context "if critical saving raise error" do
      it 'returns false' do
        allow(subject).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(subject)
        end
        expect(subject.save).to be_false
      end
    end

    context "if critical saving doesn't raise error" do
      it 'returns false' do
        allow(subject).to receive(:save!)
        expect(subject.save).to be_true
      end
    end
  end

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
