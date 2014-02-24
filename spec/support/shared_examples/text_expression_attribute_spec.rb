shared_examples "text expression attribute" do
  let(:setter_method) {:"#{expression_name}="}
  let(:getter_method) {expression_name}

  describe "when setting a new" do
    describe "creates a text expression" do
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
