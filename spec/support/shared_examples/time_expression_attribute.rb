shared_examples "time expression attribute" do
  let(:set_reference_method) {:"set_#{expression_name}_reference"}
  let(:update_method) {:"update_#{expression_name}"}
  let(:setter_method) {:"#{expression_name}="}
  let(:getter_method) {expression_name}

  let(:valid_date_str) {"22/03/1993 10:30"}

  describe "when updating" do
    before :each do
      @old_expression = subject.public_send(getter_method)
      subject.public_send(update_method, valid_date_str)
      @getted_expression = subject.public_send(getter_method)
    end

    it "maintain the reference" do
      expect(@getted_expression).to be == @old_expression
    end

    it "update the time" do
      expect(@getted_expression.when).to be == DateTime.new(1993, 3, 22, 10, 30)
    end
  end

  describe "when setting the reference" do
    before :each do
      @new_expression = build(:time_expression)
      subject.public_send(set_reference_method, @new_expression)
      @getted_expression = subject.public_send(getter_method)
    end

    it "replace the old text expression by the new reference" do
      expect(@getted_expression).to be == @new_expression
    end
  end

  describe "when setting" do
    describe "initialize a new datetime" do
      before :each do
        subject.public_send(setter_method, valid_date_str)
        @expression = subject.public_send(getter_method)
      end

      it "parsing the string in format 'dd/mm/yyyy hh:mm' received" do
        expect(@expression.when).to be == DateTime.new(1993, 3, 22, 10, 30)
      end

      it "with expression model name" do
        expect(@expression.name).to be == model_name
      end
    end

    it "replace the old text expression" do
      old_exp = subject.public_send(getter_method)
      subject.public_send(setter_method, valid_date_str)
      new_exp = subject.public_send(getter_method)
      expect(new_exp).to_not be == old_exp
    end
  end

  describe "when getting" do
    before :each do
      @expression = subject.public_send(getter_method)
    end

    it "associate cycle to it" do
      expect(@expression.cycle_id).to be == subject.cycle_id
    end
  end
end
