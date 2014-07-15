shared_examples "time expression attribute" do
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

    describe "time updating" do
      context "if valid string passed" do
        before :each do
          @old_expression = subject.public_send(getter_method)
          @old_expression.text = old_text
          @old_expression.when = old_when
          @old_expression.source = "incident name"
          @old_expression.reused = true
          @dup_old_expression = @old_expression.dup
          @updated = subject.public_send(update_method, new_time_str)
          @getted_expression = subject.public_send(getter_method)
        end

        shared_examples :update_succeed do
          it 'update the owner' do
            expect(@getted_expression.owner).to be == subject.owner
          end

          it "update reused to false" do
            expect(@getted_expression).to_not be_reused
          end

          it "update source to nil" do
            expect(@getted_expression.source).to be == nil
          end

          it "return true" do
            expect(@updated).to be true
          end
        end

        shared_examples :update_fails do
          it 'the owner remains the same' do
            expect(@getted_expression.owner).to be == @dup_old_expression.owner
          end

          it 'the reused remains the same' do
            expect(@getted_expression.reused).to be == @dup_old_expression.reused
          end

          it 'the source remains the same' do
            expect(@getted_expression.source).to be == @dup_old_expression.source
          end

          it 'the text remains the same' do
            expect(@getted_expression.text).to be == @dup_old_expression.text
          end

          it 'the when remains the same' do
            expect(@getted_expression.when).to be == @dup_old_expression.when
          end

          it "return false" do
            expect(@updated).to be false
          end
        end

        context "if update text to a new one" do
          let(:old_when)  { nil }
          let(:old_text)  { "Old text" }
          let(:new_time_str) { "New text" }

          it "update when to nil" do
            expect(@getted_expression.when).to be == nil
          end

          it "update text" do
            expect(@getted_expression.text).to be == "New text"
          end

          include_examples :any_kind_of_update
          include_examples :update_succeed
        end

        context "if update when to a new one" do
          let(:old_when)  { DateTime.now.beginning_of_minute.utc }
          let(:old_text)  { "" }
          let(:new_when) {old_when >> 1}
          let(:new_time_str) {new_when.strftime(TimeExpression::TIME_PARSING_FORMAT)}

          it "update the when" do
            expect(@getted_expression.when).to be == new_when
          end

          include_examples :any_kind_of_update
          include_examples :update_succeed
        end

        context "if update when to the same old" do
          let(:old_when)  { DateTime.now.beginning_of_minute.utc }
          let(:old_text)  { "" }
          let(:new_time_str) {old_when.strftime(TimeExpression::TIME_PARSING_FORMAT)}

          include_examples :any_kind_of_update
          include_examples :update_fails
        end

        context "if update text to the same old" do
          let(:old_when)  { nil }
          let(:old_text)  { "Old text" }
          let(:new_time_str) { old_text }

          include_examples :any_kind_of_update
          include_examples :update_fails
        end
      end

      context "if an empty string was passed" do
        let(:time_expression) {
          time_expression = subject.public_send(getter_method)}

        it "doesn't raise error" do
          expect do
            subject.public_send(update_method, "")
          end.to_not raise_error
        end

        it "when is set to nil" do
          subject.public_send(update_method, "")
          expect(time_expression.when).to be_nil
        end

        it "text is set to empty string" do
          subject.public_send(update_method, "")
          expect(time_expression.text).to be == ""
        end

        it "return true" do
          updated = subject.public_send(update_method, "")
          expect(updated).to be true
        end
      end
    end

    describe "reused expression update" do
      let(:old_reused){true}
      let(:old_source){nil}
      let(:old_text){""}
      let(:old_when){nil}

      before :each do
        @old_expression = subject.public_send(getter_method)
        @old_expression.reused = old_reused
        @old_expression.source = old_source
        @old_expression.text = old_text
        @old_expression.when = old_when
        @dup_old_expression = @old_expression.dup
        @new_time = DateTime.now.beginning_of_minute
        @updated = subject.public_send(reused_update_method, new_reused_expression)
        @getted_expression = subject.public_send(getter_method)
      end

      shared_examples :general_reused_update do
        it "update the reused" do
          expect(@getted_expression).to be_reused
        end

        it "update the source to the reused expression" do
          expect(@getted_expression.source).to be == new_reused_expression.source
        end

        it "update the text to the text expression" do
          expect(@getted_expression.text).to be == new_reused_expression.text
        end

        it "update the text to the when expression" do
          expect(@getted_expression.when).to be == new_reused_expression.when
        end
      end

      shared_examples :reused_update_succeed do
        it "update the owner" do
          expect(@getted_expression.owner).to be == subject.owner
        end

        it "returns true" do
          expect(@updated).to be == true
        end
      end

      context "if text change" do
        let(:old_text){ "Old text" }
        let :new_reused_expression do
          build :time_expression,
            source: old_source,
            text: "New text",
            when: old_when
        end

        include_examples :any_kind_of_update
        include_examples :general_reused_update
        include_examples :reused_update_succeed
      end

      context "if when change" do
        let(:old_when){ nil }
        let :new_reused_expression do
          build :time_expression,
            source: old_source,
            text: old_text,
            when: DateTime.now
        end

        include_examples :any_kind_of_update
        include_examples :general_reused_update
        include_examples :reused_update_succeed
      end

      context "if source change" do
        let(:old_source){ "Old Source" }
        let :new_reused_expression do
          build :time_expression,
            source: "New Source",
            text: old_text,
            when: old_when
        end

        include_examples :any_kind_of_update
        include_examples :general_reused_update
        include_examples :reused_update_succeed
      end

      context "if reused change" do
        let(:old_reused){ false }
        let :new_reused_expression do
          build :time_expression,
            source: old_source,
            text: old_text,
            when: old_when
        end

        include_examples :any_kind_of_update
        include_examples :general_reused_update
        include_examples :reused_update_succeed
      end

      context "if nothing changes change" do
        let(:old_reused){ true }
        let :new_reused_expression do
          build :time_expression,
            source: old_source,
            text: old_text,
            when: old_when
        end

        include_examples :any_kind_of_update
        include_examples :general_reused_update

        it "owner remains the same" do
          expect(@getted_expression.owner).to be == @dup_old_expression.owner
        end

        it "returns false" do
          expect(@updated).to be == false
        end
      end

      context "if try to reuse nil" do
        let(:new_reused_expression) { nil }

        it "have same old source" do
          expect(@getted_expression.source).to be == @dup_old_expression.source
        end

        it "have same old text" do
          expect(@getted_expression.text).to be == @dup_old_expression.text
        end

        it "have same old when" do
          expect(@getted_expression.when).to be == @dup_old_expression.when
        end

        it "have same old reused" do
          expect(@getted_expression.reused).to be == @dup_old_expression.reused
        end

        it "have same old owner" do
          expect(@getted_expression.owner).to be == @dup_old_expression.owner
        end

        it "returns false" do
          expect(@updated).to be == false
        end
      end
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
    shared_examples :expression_of_any_setting do
      it "have expression model name" do
        expect(@expression.name).to be == model_name
      end

      it "have model owner" do
        expect(@expression.owner).to be == subject.owner
      end

      it "have reused equals false" do
        expect(@expression).to_not be_reused
      end

      it "have source equals nil" do
        expect(@expression.source).to be == nil
      end
    end

    context "if in format 'dd/mm/yyyy hh:mm'" do
      let(:valid_date_str) {"22/03/1993 10:30"}

      describe "initialize an expression that" do
        before :each do
          subject.public_send(setter_method, valid_date_str)
          @expression = subject.public_send(getter_method)
        end

        include_examples :expression_of_any_setting

        it "with when equals parsed string" do
          expect(@expression.when).to be == DateTime.new(1993, 3, 22, 10, 30)
        end

        it "with text equals nil" do
          expect(@expression.text).to be == nil
        end
      end

      it "replace the old time expression" do
        old_exp = subject.public_send(getter_method)
        subject.public_send(setter_method, valid_date_str)
        new_exp = subject.public_send(getter_method)
        expect(new_exp).to_not be == old_exp
      end
    end

    context "if string have an invalid date format" do
      let(:invalid_str){"string with invalid date format"}

      describe "initialize an expression that" do
        before :each do
          subject.public_send(setter_method, invalid_str)
          @expression = subject.public_send(getter_method)
        end

        it "with text equals string passed" do
          expect(@expression.text).to be == invalid_str
        end

        it "with when equals nil" do
          expect(@expression.when).to be == nil
        end

        include_examples :expression_of_any_setting
      end

      it "replace the old time expression" do
        old_exp = subject.public_send(getter_method)
        subject.public_send(setter_method, invalid_str)
        new_exp = subject.public_send(getter_method)
        expect(new_exp).to_not be == old_exp
      end
    end
  end

  describe "when setting from reused expression" do
    context "passing an expression" do
      before :each do
        @old_expression = subject.public_send(getter_method)
        @reused_expression = build :time_expression,
          source: "Reused Source",
          text: "Reused Text",
          when: DateTime.now.beginning_of_minute
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

        it "have same when of reused expression" do
          expect(@expression.when).to be == @reused_expression.when
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

        it "have same old when" do
          expect(@expression.when).to be == @old_expression.when
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
      @expression = subject.public_send(getter_method)
    end

    it "associate cycle to it" do
      expect(@expression.cycle_id).to be == subject.cycle_id
    end
  end
end
