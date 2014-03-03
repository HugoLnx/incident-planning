require 'spec_helper'

describe HighModels::Tactic do
  it_behaves_like "High Model"

  describe "when initializing" do
    before :each do
      @tactic = build :high_models_tactic,
        who: "Who",
        what: "What",
        where: "Where",
        when: "When",
        response_action: "ResAct",
        cycle_id: 1
    end

    it "initialize a group with tactic name and cycle_id" do
      expect(@tactic.group.name).to be == Model.tactic.name
      expect(@tactic.group.cycle_id).to be == 1
    end

    it "initialize who, what, where, when and response_action text expressions" do
      expect(@tactic.who.name).to be == Model.tactic_who.name
      expect(@tactic.what.name).to be == Model.tactic_what.name
      expect(@tactic.where.name).to be == Model.tactic_where.name
      expect(@tactic.when.name).to be == Model.tactic_when.name
      expect(@tactic.response_action.name).to be == Model.tactic_response_action.name
      expect(@tactic.who.text).to be == "Who"
      expect(@tactic.what.text).to be == "What"
      expect(@tactic.where.text).to be == "Where"
      expect(@tactic.when.text).to be == "When"
      expect(@tactic.response_action.text).to be == "ResAct"
    end
  end

  describe "when getting a group" do
    before :each do
      @tactic = build :high_models_tactic, father_id: 1, cycle_id: 2
      @group = @tactic.group
    end

    it "associate father and cycle to it" do
      expect(@group.father_id).to be == 1
      expect(@group.cycle_id).to be == 2
    end
  end

  describe "text_expression attributes" do
    subject { build :high_models_tactic }
    describe "who" do
      let(:expression_name) {:who}
      let(:model_name) {::Model.tactic_who.name}

      it_behaves_like "text expression attribute"
    end

    describe "what" do
      let(:expression_name) {:what}
      let(:model_name) {::Model.tactic_what.name}

      it_behaves_like "text expression attribute"
    end

    describe "where" do
      let(:expression_name) {:where}
      let(:model_name) {::Model.tactic_where.name}

      it_behaves_like "text expression attribute"
    end

    describe "when" do
      let(:expression_name) {:when}
      let(:model_name) {::Model.tactic_when.name}

      it_behaves_like "text expression attribute"
    end

    describe "response action" do
      let(:expression_name) {:response_action}
      let(:model_name) {::Model.tactic_response_action.name}

      it_behaves_like "text expression attribute"
    end
  end

  describe "when set from a group" do
    subject { build :high_models_tactic }

    before :each do
      @who = build :tactic_who
      @what = build :tactic_what
      @where = build :tactic_where
      @when = build :tactic_when
      @response_action = build :tactic_response_action

      @group = create :group,
        text_expressions: [@who, @what, @where, @when, @response_action],
        father: create(:group)

      subject.set_from_group @group
    end

    it "sets group" do
      expect(subject.group).to be == @group
    end

    it "sets cycle_id to the one of the group" do
      expect(subject.cycle_id).to be == @group.cycle_id
    end

    it "sets father_id to the one of the group" do
      expect(subject.father_id).to be == @group.father_id
    end

    it "the reference of text_expressions is replaced by the ones in group" do
      expect(subject.instance_variable_get(:@who)).to be == @who
      expect(subject.instance_variable_get(:@what)).to be == @what
      expect(subject.instance_variable_get(:@where)).to be == @where
      expect(subject.instance_variable_get(:@when)).to be == @when
      expect(subject.instance_variable_get(:@response_action)).to be == @response_action
    end
  end

  describe "when checking if is valid" do
    context "returns true when" do
      specify "have all the parameters, valids father_id and cycle_id" do
        @tactic = build :high_models_tactic
        expect(@tactic.save).to be_true
      end

      specify "haven't when" do
        @tactic = build :high_models_tactic, when: nil
        expect(@tactic.save).to be_true
      end

      specify "haven't response_action" do
        @tactic = build :high_models_tactic, response_action: nil
        expect(@tactic.save).to be_true
      end
    end

    context "returns false when" do
      specify "haven't father_id" do
        @tactic = build :high_models_tactic, father_id: nil
        expect(@tactic.save).to be_false
      end

      specify "haven't cycle_id" do
        @tactic = build :high_models_tactic, cycle_id: nil
        expect(@tactic.save).to be_false
      end

      specify "haven't who" do
        @tactic = build :high_models_tactic, who: nil
        expect(@tactic.save).to be_false
      end

      specify "haven't what" do
        @tactic = build :high_models_tactic, what: nil
        expect(@tactic.save).to be_false
      end

      specify "haven't where" do
        @tactic = build :high_models_tactic, where: nil
        expect(@tactic.save).to be_false
      end
    end
  end

  describe "when critical saving" do
    def save_tactic
      begin
        @tactic.save!
      rescue ActiveRecord::ActiveRecordError
      end
    end
    shared_examples "a valid saving" do
      it "saves the group" do
        save_tactic
        expect(@tactic.group).to be_persisted
      end

      it "saves the who" do
        save_tactic
        expect(@tactic.who).to be_persisted
      end

      it "saves the what" do
        save_tactic
        expect(@tactic.what).to be_persisted
      end

      it "saves the where" do
        save_tactic
        expect(@tactic.where).to be_persisted
      end

      it "saves the when" do
        save_tactic
        expect(@tactic.when).to be_persisted
      end

      it "saves the response_action" do
        save_tactic
        expect(@tactic.response_action).to be_persisted
      end

      it "doesn't raise an error" do
        expect{@tactic.save!}.to_not raise_error
      end
    end

    shared_examples "an invalid saving" do
      it "does not save group" do
        save_tactic
        expect(@tactic.group).to_not be_persisted
      end

      it "does not save who expression" do
        save_tactic
        expect(@tactic.who).to_not be_persisted
      end

      it "does not save what expression" do
        save_tactic
        expect(@tactic.what).to_not be_persisted
      end

      it "does not save where expression" do
        save_tactic
        expect(@tactic.where).to_not be_persisted
      end

      it "does not save when expression" do
        save_tactic
        expect(@tactic.when).to_not be_persisted
      end

      it "does not save response_action expression" do
        save_tactic
        expect(@tactic.response_action).to_not be_persisted
      end

      it "raise an error" do
        expect{@tactic.save!}.to raise_error ActiveRecord::ActiveRecordError
      end
    end

    context "if is valid" do
      before :each do
        @tactic = build :high_models_tactic
      end

      it_behaves_like "a valid saving"
    end

    context "if group is not valid" do
      before :each do
        @tactic = build :high_models_tactic

        allow(@tactic.group).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@tactic.group)
        end
      end

      it_behaves_like "an invalid saving"
    end

    context "if who is not valid" do
      before :each do
        @tactic = build :high_models_tactic,
          who: "Someone"

        allow(@tactic.who).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@tactic.who)
        end
      end

      it_behaves_like "an invalid saving"
    end

    context "if what is not valid" do
      before :each do
        @tactic = build :high_models_tactic,
          what: "Something"

        allow(@tactic.what).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@tactic.what)
        end
      end

      it_behaves_like "an invalid saving"
    end

    context "if where is not valid" do
      before :each do
        @tactic = build :high_models_tactic,
          where: "Somewhere"

        allow(@tactic.where).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@tactic.where)
        end
      end

      it_behaves_like "an invalid saving"
    end

    context "if who is not valid" do
      before :each do
        @tactic = build :high_models_tactic,
          when: "Sometime"

        allow(@tactic.when).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@tactic.when)
        end
      end

      it_behaves_like "an invalid saving"
    end

    context "if response_action is not valid" do
      before :each do
        @tactic = build :high_models_tactic,
          response_action: "Response"

        allow(@tactic.response_action).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@tactic.response_action)
        end
      end

      it_behaves_like "an invalid saving"
    end
  end
end
