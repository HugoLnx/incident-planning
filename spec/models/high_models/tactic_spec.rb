require 'spec_helper'

describe HighModels::Tactic do
  it_behaves_like "High Model"

  describe "when initializing" do
    before :each do
      @tactic = build :high_models_tactic,
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

    describe "response action" do
      let(:expression_name) {:response_action}
      let(:model_name) {::Model.tactic_response_action.name}

      it_behaves_like "text expression attribute"
    end
  end

  describe "time_expression attributes", only: true do
    subject { build :high_models_tactic }

    describe "when" do
      let(:expression_name) {:when}
      let(:model_name) {::Model.tactic_when.name}

      it_behaves_like "time expression attribute"
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
        text_expressions: [@who, @what, @where, @response_action],
        time_expressions: [@when],
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
        @tactic = build :high_models_tactic

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
  
  describe "when critical destroying" do
    before :each do
      @tactic = create :high_models_tactic
    end

    def destroy_tactic
      begin
        @tactic.destroy!
      rescue ActiveRecord::ActiveRecordError
      end
    end

    shared_examples "destroys all models" do
      it "destroys the group" do
        destroy_tactic
        expect(@tactic.group).to be_destroyed
      end

      it "destroys who expression" do
        destroy_tactic
        expect(@tactic.who).to be_destroyed
      end

      it "destroys what expression" do
        destroy_tactic
        expect(@tactic.what).to be_destroyed
      end

      it "destroys where expression" do
        destroy_tactic
        expect(@tactic.where).to be_destroyed
      end

      it "destroys when expression" do
        destroy_tactic
        expect(@tactic.when).to be_destroyed
      end

      it "destroys response_action expression" do
        destroy_tactic
        expect(@tactic.response_action).to be_destroyed
      end
    end

    shared_examples "any model is destroyed" do
      it "doesn't destroy the group" do
        destroy_tactic
        expect(@tactic.group).to_not be_destroyed
      end

      it "doesn't destroy who expression" do
        destroy_tactic
        expect(@tactic.who).to_not be_destroyed
      end

      it "doesn't destroy what expression" do
        destroy_tactic
        expect(@tactic.what).to_not be_destroyed
      end

      it "doesn't destroy where expression" do
        destroy_tactic
        expect(@tactic.where).to_not be_destroyed
      end

      it "doesn't destroy when expression" do
        destroy_tactic
        expect(@tactic.when).to_not be_destroyed
      end

      it "doesn't destroy response_action expression" do
        destroy_tactic
        expect(@tactic.response_action).to_not be_destroyed
      end
    end

    context "when all associations can be destroyed" do
      include_examples "destroys all models"
    end

    context "when group can't be destroyed" do
      before :each do
        allow(@tactic.group).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      include_examples "any model is destroyed"
    end

    context "when who can't be destroyed" do
      before :each do
        allow(@tactic.who).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      include_examples "any model is destroyed"
    end

    context "when what can't be destroyed" do
      before :each do
        allow(@tactic.what).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      include_examples "any model is destroyed"
    end

    context "when where can't be destroyed" do
      before :each do
        allow(@tactic.where).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      include_examples "any model is destroyed"
    end

    context "when when can't be destroyed" do
      before :each do
        allow(@tactic.when).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      include_examples "any model is destroyed"
    end

    context "when response_action can't be destroyed" do
      before :each do
        allow(@tactic.response_action).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      include_examples "any model is destroyed"
    end
  end
end
