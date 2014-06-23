shared_examples "text expression attribute" do
  let(:update_method) {:"update_#{expression_name}"}
  let(:setter_method) {:"#{expression_name}="}

  let(:reused_update_method) {:"update_#{expression_name}_reused"}
  let(:reused_setter_method) {:"#{expression_name}_reused="}

  let(:set_reference_method) {:"set_#{expression_name}_reference"}
  let(:getter_method) {expression_name}

  describe "when updating" do
    shared_examples "any_kind_of_update" do
      it "maintain the reference" do
        expect(@getted_expression).to be == @old_expression
      end
    end

    describe "text updating" do
      before :each do
        @old_expression = subject.public_send(getter_method)
        @old_expression.reused_expression_id = 99
        subject.public_send(update_method, new_text)
        @getted_expression = subject.public_send(getter_method)
      end

      shared_examples 'general_text_update' do
        it "update the text" do
          expect(@getted_expression.text).to be == new_text
        end
      end

      context "if text change" do
        let(:new_text) {@old_expression.text + "A"}

        it "update the owner" do
          expect(@getted_expression.owner).to be == subject.owner
        end

        it "update reused_expression_id to nil" do
          expect(@getted_expression.reused_expression_id)
            .to be_nil
        end

        include_examples 'any_kind_of_update'
        include_examples 'general_text_update'
      end

      context "if text doesn't change" do
        let(:new_text) {@old_expression.text}

        it "owner remains the same" do
          expect(@getted_expression.owner).to be == @old_expression.owner
        end

        include_examples 'any_kind_of_update'
        include_examples 'general_text_update'
      end
    end

    describe "reused expression update" do
      before :each do
        @old_expression = subject.public_send(getter_method)
        @old_expression.reused_expression_id = 120
        @old_expression.text = ""
        subject.public_send(reused_update_method, new_reused_id)
        @getted_expression = subject.public_send(getter_method)
      end

      shared_examples 'general_reused_update' do
        it "update the reused_id" do
          expect(@getted_expression.reused_expression_id)
            .to be == new_reused_id
        end
      end

      context "if reused id change" do
        let(:new_reused_id) {(@old_expression.reused_expression_id || 0) + 1}

        it "update the owner" do
          expect(@getted_expression.owner).to be == subject.owner
        end

        it "update text to blank" do
          expect(@getted_expression.text).to be_blank
        end

        include_examples 'any_kind_of_update'
        include_examples 'general_reused_update'
      end

      context "if reused id doesn't change" do
        let(:new_reused_id) {@old_expression.reused_expression_id}

        it "owner remains the same" do
          expect(@getted_expression.owner).to be == @old_expression.owner
        end

        include_examples 'any_kind_of_update'
        include_examples 'general_reused_update'
      end
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
    shared_examples "initialized_expression_reused_and_regular_commons" do
      it "have expression's name" do
        expect(@text_expression.name).to be == model_name
      end

      it "have model owner" do
        expect(@text_expression.owner).to be == subject.owner
      end
    end

    describe "reused expression" do
      it "replace the old text expression" do
        old_exp = subject.public_send(getter_method)
        subject.public_send(reused_setter_method, 120)
        new_exp = subject.public_send(getter_method)
        expect(new_exp).to_not be == old_exp
      end

      describe "initialize a new text expression that" do
        before :each do
          subject.public_send(reused_setter_method, 120)
          @text_expression = subject.public_send(getter_method)
        end

        it "have text blank" do
          expect(@text_expression.text).to be_blank
        end

        it "have reused_expression_id" do
          expect(@text_expression.reused_expression_id)
            .to be == 120
        end
      end
    end

    describe "regular expression" do
      it "replace the old text expression" do
        old_exp = subject.public_send(getter_method)
        subject.public_send(setter_method, "Text")
        new_exp = subject.public_send(getter_method)
        expect(new_exp).to_not be == old_exp
      end

      describe "initialize a new text expression that" do
        before :each do
          subject.public_send(setter_method, "Text")
          @text_expression = subject.public_send(getter_method)
        end

        include_examples "initialized_expression_reused_and_regular_commons"

        it "with the text received" do
          expect(@text_expression.text).to be == "Text"
        end

        it "with reused_expression_id equals nil" do
          expect(@text_expression.reused_expression_id).to be_nil
        end
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
