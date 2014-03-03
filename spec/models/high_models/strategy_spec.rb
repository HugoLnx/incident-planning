require 'spec_helper'

describe HighModels::Strategy do
  subject {build :high_models_strategy}
  it_behaves_like "High Model"

  describe "when initializing" do
    before :each do
      @strategy = build :high_models_strategy, how: "How", why: "Why", cycle_id: 1
    end

    it "initialize a group with strategy name and cycle_id" do
      expect(@strategy.group.name).to be == Model.strategy.name
      expect(@strategy.group.cycle_id).to be == 1
    end

    it "initialize how and why text expressions" do
      expect(@strategy.how.name).to be == Model.strategy_how.name
      expect(@strategy.why.name).to be == Model.strategy_why.name
      expect(@strategy.how.text).to be == "How"
      expect(@strategy.why.text).to be == "Why"
    end
  end

  describe "when getting a group" do
    before :each do
      @strategy = build :high_models_strategy
      @group = @strategy.group
    end

    it "associate father and cycle to it" do
      expect(@group.father_id).to be == @strategy.father_id
      expect(@group.cycle_id).to be == @strategy.cycle_id
    end
  end

  describe "text expression attributes" do
    subject { build :high_models_strategy }

    describe "how" do
      it_behaves_like "text expression attribute" do
        let(:expression_name) {:how}
        let(:model_name) {::Model.strategy_how.name}
      end
    end

    describe "why" do
      it_behaves_like "text expression attribute" do
        let(:expression_name) {:why}
        let(:model_name) {::Model.strategy_why.name}
      end
    end
  end

  describe "when set from a group" do
    subject { build :high_models_strategy }

    before :each do
      @how = build :strategy_how
      @why = build :strategy_why

      @group = create :group,
        text_expressions: [@how, @why],
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
      expect(subject.instance_variable_get(:@how)).to be == @how
      expect(subject.instance_variable_get(:@why)).to be == @why
    end
  end

  describe "when checking if is valid" do
    context "returns true when" do
      specify "have all the parameters, valids father_id and cycle_id" do
        @strategy = build :high_models_strategy
        expect(@strategy.save).to be_true
      end

      specify "haven't why" do
        @strategy = build :high_models_strategy, why: nil
        expect(@strategy.save).to be_true
      end
    end

    context "returns false when" do
      specify "haven't father_id" do
        @strategy = build :high_models_strategy, father_id: nil
        expect(@strategy.save).to be_false
      end

      specify "haven't cycle_id" do
        @strategy = build :high_models_strategy, cycle_id: nil
        expect(@strategy.save).to be_false
      end

      specify "haven't how" do
        @strategy = build :high_models_strategy, how: nil
        expect(@strategy.save).to be_false
      end
    end
  end

  describe "when critical saving" do
    def save_strategy
      begin
        @strategy.save!
      rescue ActiveRecord::ActiveRecordError
      end
    end

    shared_examples "a valid saving" do
      it "saves the group" do
        save_strategy
        expect(@strategy.group).to be_persisted
      end

      it "saves the how" do
        save_strategy
        expect(@strategy.how).to be_persisted
      end

      it "saves the why" do
        save_strategy
        expect(@strategy.why).to be_persisted
      end

      it "does not raise error" do
        expect{@strategy.save!}.to_not raise_error
      end
    end

    shared_examples "an invalid saving" do
      it "does not save group" do
        save_strategy
        expect(@strategy.group).to_not be_persisted
      end

      it "does not save how expression" do
        save_strategy
        expect(@strategy.how).to_not be_persisted
      end

      it "does not save why expression" do
        save_strategy
        expect(@strategy.why).to_not be_persisted
      end

      it "raise an ActiveRecordError" do
        expect{@strategy.save!}.to raise_error ActiveRecord::ActiveRecordError
      end
    end

    context "if is valid" do
      before :each do
        @strategy = build :high_models_strategy
      end

      it_behaves_like "a valid saving"
    end

    context "if group is not valid" do
      before :each do
        @strategy = build :high_models_strategy

        allow(@strategy.group).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@strategy.group)
        end
      end

      it_behaves_like "an invalid saving"
    end

    context "if how is not valid" do
      before :each do
        @strategy = build :high_models_strategy

        allow(@strategy.how).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@strategy.how)
        end
      end

      it_behaves_like "an invalid saving"
    end

    context "if why is not valid" do
      before :each do
        @strategy = build :high_models_strategy

        allow(@strategy.why).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@strategy.why)
        end
      end

      it_behaves_like "an invalid saving"
    end
  end
  
  describe "when critical destroying" do
    before :each do
      @strategy = create :high_models_strategy
    end

    def destroy_strategy
      begin
        @strategy.destroy!
      rescue ActiveRecord::ActiveRecordError
      end
    end

    shared_examples "destroys all models" do
      it "destroys the group" do
        destroy_strategy
        expect(@strategy.group).to be_destroyed
      end

      it "destroys how expression" do
        destroy_strategy
        expect(@strategy.how).to be_destroyed
      end

      it "destroys why expression" do
        destroy_strategy
        expect(@strategy.why).to be_destroyed
      end
    end

    shared_examples "any model is destroyed" do
      it "doesn't destroy the group" do
        destroy_strategy
        expect(@strategy.group).to_not be_destroyed
      end

      it "doesn't destroy how expression" do
        destroy_strategy
        expect(@strategy.how).to_not be_destroyed
      end

      it "doesn't destroy why expression" do
        destroy_strategy
        expect(@strategy.why).to_not be_destroyed
      end
    end

    context "when all associations can be destroyed" do
      include_examples "destroys all models"
    end

    context "when group can't be destroyed" do
      before :each do
        allow(@strategy.group).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      include_examples "any model is destroyed"
    end

    context "when how can't be destroyed" do
      before :each do
        allow(@strategy.how).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      include_examples "any model is destroyed"
    end

    context "when why can't be destroyed" do
      before :each do
        allow(@strategy.why).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      include_examples "any model is destroyed"
    end
  end
end
