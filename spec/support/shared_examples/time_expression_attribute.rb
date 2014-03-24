shared_examples "time expression attribute" do
  let(:set_reference_method) {:"set_#{expression_name}_reference"}
  let(:update_method) {:"update_#{expression_name}"}
  let(:setter_method) {:"#{expression_name}="}
  let(:getter_method) {expression_name}

  let(:valid_date_str) {"22/03/1993 10:30"}

  describe "when updating" do
    before :each do
      @old_expression = subject.public_send(getter_method)
      new_date_str = new_date.strftime(TimeExpression::TIME_PARSING_FORMAT)
      subject.public_send(update_method, new_date_str)
      @getted_expression = subject.public_send(getter_method)
    end

    shared_examples 'update general' do
      it "maintain the reference" do
        expect(@getted_expression).to be == @old_expression
      end

      it "update the time" do
        expect(@getted_expression.when).to be == new_date
      end
    end

    context "if time change" do
      let(:new_date) {@old_expression.when >> 1}

      it 'update the owner' do
        expect(@getted_expression.owner).to be == subject.owner
      end

      include_examples "update general"
    end

    context "if time doesn't change" do
      let(:new_date) {@old_expression.when}

      it 'the owner remains the same' do
        expect(@getted_expression.owner).to be == @old_expression.owner
      end

      include_examples "update general"
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

  describe "when setting with string" do
    context "if in format 'dd/mm/yyyy hh:mm'" do
      describe "initialize a new datetime" do
        before :each do
          subject.public_send(setter_method, valid_date_str)
          @expression = subject.public_send(getter_method)
        end

        it "parsing the string received" do
          expect(@expression.when).to be == DateTime.new(1993, 3, 22, 10, 30)
        end

        it "with expression model name" do
          expect(@expression.name).to be == model_name
        end

        it "with model owner" do
          expect(@expression.owner).to be == subject.owner
        end
      end

      it "replace the old text expression" do
        old_exp = subject.public_send(getter_method)
        subject.public_send(setter_method, valid_date_str)
        new_exp = subject.public_send(getter_method)
        expect(new_exp).to_not be == old_exp
      end
    end

    context "if string have an invalid format" do
      it 'sets expression to nil' do
        subject.public_send(setter_method, "invalid format")
        expression = subject.public_send(getter_method)
        expect(expression).to be_nil
      end
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
