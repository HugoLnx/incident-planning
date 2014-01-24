require "spec_helper"

describe Expressions::Objective do
  context "when saving" do
    context "when doesn't have a group" do
      describe "creates an group for his own" do
        before :each do
          @objective = build :objective, group: nil
          Expressions::Objective.save!(@objective)
        end

        it "put a objective group name for the new group" do
          expect(@objective.group.name).to be == Model.objective.name
        end

        it "associate your cycle to the new group" do
          expect(@objective.group.cycle).to be == @objective.cycle
        end
      end
    end

    context "when have a group" do
      before :each do
        @group = build(:objective_group)
        @objective = build :objective, group: @group
        Expressions::Objective.save! @objective
      end

      it "maintain the group" do
        expect(@objective.group).to be == @group
      end

      it "associate your cycle to the group" do
        expect(@objective.group.cycle).to be == @objective.cycle
      end
    end
  end
end
