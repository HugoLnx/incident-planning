require 'spec_helper'

describe HighModels::Tactic do
  it_behaves_like "ActiveModel"

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

  describe "when getting who text expression" do
    before :each do
      @tactic = build :high_models_tactic, cycle_id: 2
      @who = @tactic.who
    end

    it "associate cycle to it" do
      expect(@who.cycle_id).to be == 2
    end
  end

  describe "when getting what text expression" do
    before :each do
      @tactic = build :high_models_tactic, cycle_id: 2
      @what = @tactic.what
    end

    it "associate cycle to it" do
      expect(@what.cycle_id).to be == 2
    end
  end

  describe "when getting where text expression" do
    before :each do
      @tactic = build :high_models_tactic, cycle_id: 2
      @where = @tactic.where
    end

    it "associate cycle to it" do
      expect(@where.cycle_id).to be == 2
    end
  end

  describe "when getting when text expression" do
    before :each do
      @tactic = build :high_models_tactic, cycle_id: 2
      @when = @tactic.when
    end

    it "associate cycle to it" do
      expect(@when.cycle_id).to be == 2
    end
  end

  describe "when getting response_action text expression" do
    before :each do
      @tactic = build :high_models_tactic, cycle_id: 2
      @response_action = @tactic.response_action
    end

    it "associate cycle to it" do
      expect(@response_action.cycle_id).to be == 2
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

  describe "when saving" do
    shared_examples "a valid saving" do
      it "saves the group" do
        @tactic.save
        expect(@tactic.group).to be_persisted
      end

      it "saves the who" do
        @tactic.save
        expect(@tactic.who).to be_persisted
      end

      it "saves the what" do
        @tactic.save
        expect(@tactic.what).to be_persisted
      end

      it "saves the where" do
        @tactic.save
        expect(@tactic.where).to be_persisted
      end

      it "saves the when" do
        @tactic.save
        expect(@tactic.when).to be_persisted
      end

      it "saves the response_action" do
        @tactic.save
        expect(@tactic.response_action).to be_persisted
      end

      it "returns true" do
        expect(@tactic.save).to be_true
      end
    end

    shared_examples "an invalid saving" do
      it "does not save group" do
        expect(@tactic.group).to_not be_persisted
      end

      it "does not save who expression" do
        expect(@tactic.who).to_not be_persisted
      end

      it "does not save what expression" do
        expect(@tactic.what).to_not be_persisted
      end

      it "does not save where expression" do
        expect(@tactic.where).to_not be_persisted
      end

      it "does not save when expression" do
        expect(@tactic.when).to_not be_persisted
      end

      it "does not save response_action expression" do
        expect(@tactic.response_action).to_not be_persisted
      end

      it "returns false" do
        expect(@tactic.save).to be_false
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
