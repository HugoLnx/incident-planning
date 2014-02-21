require 'spec_helper'

describe HighModels::Strategy do
  it_behaves_like "ActiveModel"

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
      @strategy = build :high_models_strategy, father_id: 1, cycle_id: 2
      @group = @strategy.group
    end

    it "associate father and cycle to it" do
      expect(@group.father_id).to be == 1
      expect(@group.cycle_id).to be == 2
    end
  end

  describe "when getting how text expression" do
    before :each do
      @strategy = build :high_models_strategy, cycle_id: 2
      @how = @strategy.how
    end

    it "associate cycle to it" do
      expect(@how.cycle_id).to be == 2
    end
  end

  describe "when getting why text expression" do
    before :each do
      @strategy = build :high_models_strategy, cycle_id: 2
      @why = @strategy.why
    end

    it "associate cycle to it" do
      expect(@why.cycle_id).to be == 2
    end
  end

  describe "when setting how text expression" do
    context "if strategy haven't a how yet" do
      before :each do
        @strategy = build :high_models_strategy, cycle_id: 2, how: nil
      end

      describe "creates a text expression" do
        before :each do
          @strategy.how = "Text"
          @text_expression = @strategy.how
        end

        it "with the text received" do
          expect(@text_expression.text).to be == "Text"
        end

        it "with how expression's name" do
          expect(@text_expression.name).to be == ::Model.strategy_how.name
        end
      end
    end
  end

  describe "when setting why text expression" do
    context "if strategy haven't a why yet" do
      before :each do
        @strategy = build :high_models_strategy, cycle_id: 2, why: nil
      end

      describe "creates a text expression" do
        before :each do
          @strategy.why = "Text"
          @text_expression = @strategy.why
        end

        it "with the text received" do
          expect(@text_expression.text).to be == "Text"
        end

        it "with why expression's name" do
          expect(@text_expression.name).to be == ::Model.strategy_why.name
        end
      end
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

  describe "when saving" do
    shared_examples "a valid saving" do
      it "saves the group" do
        @strategy.save
        expect(@strategy.group).to be_persisted
      end

      it "saves the how" do
        @strategy.save
        expect(@strategy.how).to be_persisted
      end

      it "saves the why" do
        @strategy.save
        expect(@strategy.why).to be_persisted
      end

      it "returns true" do
        expect(@strategy.save).to be_true
      end
    end

    shared_examples "an invalid saving" do
      it "does not save group" do
        expect(@strategy.group).to_not be_persisted
      end

      it "does not save how expression" do
        expect(@strategy.how).to_not be_persisted
      end

      it "does not save why expression" do
        expect(@strategy.why).to_not be_persisted
      end

      it "returns false" do
        expect(@strategy.save).to be_false
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
        @strategy = HighModels::Strategy.new(
          father_id: 1, cycle_id: 2,
          how: "Something", why: "Doing something"
        )

        allow(@strategy.how).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@strategy.how)
        end
      end

      it_behaves_like "an invalid saving"
    end

    context "if why is not valid" do
      before :each do
        @strategy = HighModels::Strategy.new(
          father_id: 1, cycle_id: 2,
          how: "Something", why: "Doing something"
        )

        allow(@strategy.why).to receive(:save!) do
          raise ActiveRecord::RecordInvalid.new(@strategy.why)
        end
      end

      it_behaves_like "an invalid saving"
    end
  end
end
