shared_examples "text expression attribute" do
  let(:set_reference_method) {:"set_#{expression_name}_reference"}
  let(:update_method) {:"update_#{expression_name}"}
  let(:setter_method) {:"#{expression_name}="}
  let(:getter_method) {expression_name}

  describe "when updating" do
    before :each do
      @old_expression = subject.public_send(getter_method)
      subject.public_send(update_method, new_text)
      @getted_expression = subject.public_send(getter_method)
    end

    shared_examples 'general update' do
      it "maintain the reference" do
        expect(@getted_expression).to be == @old_expression
      end

      it "update the text" do
        expect(@getted_expression.text).to be == new_text
      end
    end

    context "if text change" do
      let(:new_text) {@old_expression.text + "A"}

      it "update the owner" do
        expect(@getted_expression.owner).to be == subject.owner
      end

      include_examples 'general update'
    end

    context "if text doesn't change" do
      let(:new_text) {@old_expression.text}

      before :each do
        subject.public_send(update_method, new_text)
        @getted_expression = subject.public_send(getter_method)
      end

      it "owner remains the same" do
        expect(@getted_expression.owner).to be == @old_expression.owner
      end

      include_examples 'general update'
    end
  end

  describe "when setting the reference" do
    before :each do
      @new_expression = build(:text_expression, text: "Text")
      subject.public_send(set_reference_method, @new_expression)
      @getted_expression = subject.public_send(getter_method)
    end

    it "replace the old text expression by the new reference" do
      expect(@getted_expression).to be == @new_expression
    end
  end

  describe "when setting" do
    describe "initialize a new text expression" do
      before :each do
        subject.public_send(setter_method, "Text")
        @text_expression = subject.public_send(getter_method)
      end

      it "with the text received" do
        expect(@text_expression.text).to be == "Text"
      end

      it "with how expression's name" do
        expect(@text_expression.name).to be == model_name
      end

      it "with model owner" do
        expect(@text_expression.owner).to be == subject.owner
      end
    end

    it "replace the old text expression" do
      old_exp = subject.public_send(getter_method)
      subject.public_send(setter_method, "Text")
      new_exp = subject.public_send(getter_method)
      expect(new_exp).to_not be == old_exp
    end
  end

  describe "when getting" do
    before :each do
      @text_expression = subject.public_send(getter_method)
    end

    it "associate cycle to it" do
      expect(@text_expression.cycle_id).to be == subject.cycle_id
    end
  end
end
