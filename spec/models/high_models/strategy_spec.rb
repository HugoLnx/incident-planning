require 'spec_helper'

describe HighModels::Strategy do
  subject {build :high_models_strategy}
  it_behaves_like "High Model"

  describe "when initializing" do
    before :each do
      @strategy = build :high_models_strategy, 
        how: "How",
        cycle_id: 1,
        owner: create(:user)
    end

    it "initialize a group with strategy name and cycle_id" do
      expect(@strategy.group.name).to be == Model.strategy.name
      expect(@strategy.group.cycle_id).to be == 1
    end

    it "initialize how text expression" do
      expect(@strategy.how.name).to be == Model.strategy_how.name
      expect(@strategy.how.text).to be == "How"
      expect(@strategy.how.owner).to be == @strategy.owner
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

  describe "when setting the owner" do
    subject {build :high_models_strategy}
    context "if how doesn't have an owner" do
      before :each do
        subject.how.owner = nil
        subject.owner = build :user
      end

      it "sets how owner" do
        expect(subject.how.owner).to be == subject.owner
      end
    end

    context "if how already have an owner" do
      before :each do
        @how_old_owner = create :user
        subject.how.owner = @how_old_owner
        subject.owner = build :user
      end

      it "how's owner keeps the same" do
        expect(subject.how.owner).to be == @how_old_owner
      end
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
  end

  describe "when set from a group" do
    subject { build :high_models_strategy }

    before :each do
      @how = build :strategy_how

      @group = create :group,
        text_expressions: [@how],
        father: create(:group)

      @old_owner = subject.owner
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
    end

    it "doesn't change the owner" do
      expect(subject.owner).to be == @old_owner
    end
  end

  describe "when checking if is valid" do
    context "returns true when" do
      specify "have all the parameters, valids father_id and cycle_id" do
        @strategy = build :high_models_strategy
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

        InvalidSavingStubber.new(self).stub(@strategy.group)
      end

      it_behaves_like "an invalid saving"
    end

    context "if how is not valid" do
      before :each do
        @strategy = build :high_models_strategy

        InvalidSavingStubber.new(self).stub(@strategy.how)
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

    context "when group can be destroyed" do
      it "destroys the group" do
        destroy_strategy
        expect(Group.exists?(@strategy.group)).to be_false
      end

      it "destroys how expression" do
        destroy_strategy
        expect(TextExpression.exists?(@strategy.how.id)).to be_false
      end
    end

    context "when group can't be destroyed" do
      before :each do
        allow(@strategy.group).to receive(:destroy!)
          .and_raise(ActiveRecord::RecordNotDestroyed)
      end

      it "doesn't destroy the group" do
        destroy_strategy
        expect(Group.exists?(@strategy.group)).to be_true
      end

      it "doesn't destroy how expression" do
        destroy_strategy
        expect(TextExpression.exists?(@strategy.how.id)).to be_true
      end
    end
  end
end
