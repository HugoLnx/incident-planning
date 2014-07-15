shared_examples "text expression attribute" do
  let(:update_method) {:"update_#{expression_name}"}
  let(:setter_method) {:"#{expression_name}="}

  let(:reused_update_method) {:"update_#{expression_name}_reused"}
  let(:reused_setter_method) {:"#{expression_name}_reused="}

  let(:set_reference_method) {:"set_#{expression_name}_reference"}
  let(:getter_method) {expression_name}

  describe "when updating" do
    shared_examples :any_kind_of_update do
      it "maintain the reference" do
        expect(@getted_expression).to be == @old_expression
      end
    end

    describe "text updating" do
      before :each do
        @old_expression = subject.public_send(getter_method)
        @old_expression.text = "Old Text"
        @old_expression.reused = true
        @old_expression.source = "Old Source"
        @dup_old_expression = @old_expression.dup
        subject.public_send(update_method, new_text)
        @getted_expression = subject.public_send(getter_method)
      end

      context "if text change" do
        let(:new_text) {"New text"}

        it "update the owner" do
          expect(@getted_expression.owner).to be == subject.owner
        end

        it "update reused to false" do
          expect(@getted_expression.reused).to be == false
        end

        it "update source to nil" do
          expect(@getted_expression.source).to be == nil
        end

        it "update the text" do
          expect(@getted_expression.text).to be == new_text
        end

        include_examples :any_kind_of_update
      end

      context "if text doesn't change" do
        let(:new_text) {@old_expression.text}

        it "owner remains the same" do
          expect(@getted_expression.owner).to be == @dup_old_expression.owner
        end

        it "reused remains the same" do
          expect(@getted_expression.reused).to be == @dup_old_expression.reused
        end

        it "source remains the same" do
          expect(@getted_expression.source).to be == @dup_old_expression.source
        end

        include_examples :any_kind_of_update
      end
    end

    describe "reused expression update" do
      # valid old params
      let(:old_text)  { "Old text" }
      let(:old_source)  { "Old source" }
      let(:old_reused) { true }

      before :each do
        @old_expression = subject.public_send(getter_method)
        @old_expression.reused = old_reused
        @old_expression.source = old_source
        @old_expression.text = old_text
        @old_expression.owner = create :user
        @dup_old_expression = @old_expression.dup
        @updated = subject.public_send(reused_update_method, new_reused_expression)
        @getted_expression = subject.public_send(getter_method)
      end

      shared_examples :update_succeed do
        it "update the reused to true" do
          expect(@getted_expression.reused).to be == true
        end

        it "update the text to reused expression text" do
          expect(@getted_expression.text).to be == new_reused_expression.text
        end

        it "update the source to reused expression source" do
          expect(@getted_expression.source).to be == new_reused_expression.source
        end

        it "update the owner" do
          expect(@getted_expression.owner).to be == subject.owner
        end

        it "returns true" do
          expect(@updated).to be == true
        end
      end

      shared_examples :update_fails do
        it "owner remains the same" do
          expect(@getted_expression.owner).to be == @dup_old_expression.owner
        end

        it "reused remains the same" do
          expect(@getted_expression.reused).to be == @dup_old_expression.reused
        end

        it "source remains the same" do
          expect(@getted_expression.source).to be == @dup_old_expression.source
        end

        it "text remains the same" do
          expect(@getted_expression.text).to be == @dup_old_expression.text
        end

        it "returns false" do
          expect(@updated).to be == false
        end
      end

      context "if text change" do
        let(:old_text)  { "Old text" }
        let :new_reused_expression do
          build :text_expression,
            text: "New Text",
            source: old_source
        end

        include_examples :any_kind_of_update
        include_examples :update_succeed
      end

      context "if source change" do
        let(:old_source)  { "Old source" }
        let :new_reused_expression do
          build :text_expression,
            text: old_text,
            source: "New source"
        end

        include_examples :any_kind_of_update
        include_examples :update_succeed
      end

      context "if reused change" do
        let(:old_reused)  { false }
        let :new_reused_expression do
          build :text_expression,
            text: old_text,
            source: old_source
        end

        include_examples :any_kind_of_update
        include_examples :update_succeed
      end

      context "if nothing changes" do
        let :new_reused_expression do
          build :text_expression,
            text: old_text,
            source: old_source
        end

        include_examples :any_kind_of_update
        include_examples :update_fails
      end

      context "if try to reuse nil" do
        let(:new_reused_expression) { nil }

        include_examples :any_kind_of_update
        include_examples :update_fails
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

        it "with the text received" do
          expect(@text_expression.text).to be == "Text"
        end

        it "with reused equals false" do
          expect(@text_expression).to_not be_reused
        end

        it "with source equals nil" do
          expect(@text_expression.source).to be_nil
        end

        it "with expression's name" do
          expect(@text_expression.name).to be == model_name
        end

        it "with model owner" do
          expect(@text_expression.owner).to be == subject.owner
        end

      end
    end
  end

  describe "when setting from reused expression" do
    context "passing an expression" do
      before :each do
        @old_expression = subject.public_send(getter_method)
        @reused_expression = build :text_expression,
          source: "Reused Source",
          text: "Reused Text"
        subject.public_send(reused_setter_method, @reused_expression)
        @expression = subject.public_send(getter_method)
      end

      describe "creates a new expression that" do
        it "have same source of reused expression" do
          expect(@expression.source).to be == "Reused Source"
        end

        it "have same text of reused expression" do
          expect(@expression.text).to be == "Reused Text"
        end

        it "have reused equals true" do
          expect(@expression).to be_reused
        end

        it "have high model's owner" do
          expect(@expression.owner).to be == subject.owner
        end
      end
    end

    context "passing nil" do
      before :each do
        @old_expression = subject.public_send(getter_method)
        subject.public_send(reused_setter_method, nil)
        @expression = subject.public_send(getter_method)
      end

      describe "creates a new expression that" do
        it "have same old source" do
          expect(@expression.source).to be == @old_expression.source
        end

        it "have same old text" do
          expect(@expression.text).to be == @old_expression.text
        end

        it "have same old reused" do
          expect(@expression.reused).to be == @old_expression.reused
        end

        it "have same old owner" do
          expect(@expression.owner).to be == @old_expression.owner
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
