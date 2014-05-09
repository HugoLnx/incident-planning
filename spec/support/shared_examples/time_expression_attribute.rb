shared_examples "time expression attribute" do
  let(:set_reference_method) {:"set_#{expression_name}_reference"}
  let(:update_method) {:"update_#{expression_name}"}
  let(:setter_method) {:"#{expression_name}="}
  let(:getter_method) {expression_name}

  let(:valid_date_str) {"22/03/1993 10:30"}

  describe "when updating", only: true do
    context "if valid string passed" do
      before :each do
        @old_expression = subject.public_send(getter_method)
        new_date_str = new_date.strftime(TimeExpression::TIME_PARSING_FORMAT)
        @updated = subject.public_send(update_method, new_date_str)
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

        it "return true" do
          expect(@updated).to be true
        end

        include_examples "update general"
      end

      context "if time doesn't change" do
        let(:new_date) {@old_expression.when}

        it 'the owner remains the same' do
          expect(@getted_expression.owner).to be == @old_expression.owner
        end

        it "return false" do
          expect(@updated).to be false
        end

        include_examples "update general"
      end
    end

    context "if an empty string was passed" do
      it "doesn't raise error" do
        expect do
          subject.public_send(update_method, "")
        end.to_not raise_error
      end

      it "when is set to nil" do
        time_expression = subject.public_send(getter_method)
        subject.public_send(update_method, "")
        expect(time_expression.when).to be_nil
      end

      it "text is set to empty string" do
        time_expression = subject.public_send(getter_method)
        subject.public_send(update_method, "")
        expect(time_expression.text).to be == ""
      end

      it "return true" do
        updated = subject.public_send(update_method, "")
        expect(updated).to be true
      end
    end

    context "if invalid string was passed" do
      it "doesn't raise error" do
        expect do
          subject.public_send(update_method, "invalid format")
        end.to_not raise_error
      end

      it "when is set to nil" do
        time_expression = subject.public_send(getter_method)
        subject.public_send(update_method, "invalid format")
        expect(time_expression.when).to be_nil
      end

      it "text is set to string passed" do
        time_expression = subject.public_send(getter_method)
        subject.public_send(update_method, "invalid format")
        expect(time_expression.text).to be == "invalid format"
      end

      it "return true" do
        updated = subject.public_send(update_method, "invalid format")
        expect(updated).to be true
      end
    end
  end

  describe "when setting the reference", only: true do
    before :each do
      @new_expression = build(:time_expression)
      subject.public_send(set_reference_method, @new_expression)
      @getted_expression = subject.public_send(getter_method)
    end

    it "replace the old text expression by the new reference" do
      expect(@getted_expression).to be == @new_expression
    end
  end

  describe "when setting with string", only: true do
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

      it "replace the old time expression" do
        old_exp = subject.public_send(getter_method)
        subject.public_send(setter_method, valid_date_str)
        new_exp = subject.public_send(getter_method)
        expect(new_exp).to_not be == old_exp
      end

      it "set text to nil" do
        subject.public_send(setter_method, valid_date_str)
        new_exp = subject.public_send(getter_method)
        expect(new_exp.text).to be_nil
      end
    end

    context "if string have an invalid format" do
      it 'sets text to the string passed' do
        subject.public_send(setter_method, "invalid format")
        expression = subject.public_send(getter_method)
        expect(expression.text).to be == "invalid format"
      end

      it 'sets when to nil' do
        subject.public_send(setter_method, "invalid format")
        expression = subject.public_send(getter_method)
        expect(expression.when).to be_nil
      end
    end
  end

  describe "when getting", only: true do
    before :each do
      @expression = subject.public_send(getter_method)
    end

    it "associate cycle to it" do
      expect(@expression.cycle_id).to be == subject.cycle_id
    end
  end
end
