require "spec_helper"

describe Expressions::Objective do
  describe "when destroying", focus: true do
    before :each do
      @groups = create_list :objective_group, 3
      @objectives = [
        create(:objective, group: @groups[0]),
        create(:objective, group: @groups[1]),
        create(:objective, group: @groups[2]),
      ]
      
      Expressions::Objective.destroy(@objectives)
    end

    it "destroy the expressions" do
      expect(TextExpression.exists?(@objectives[0].id)).to be == false
      expect(TextExpression.exists?(@objectives[1].id)).to be == false
      expect(TextExpression.exists?(@objectives[2].id)).to be == false
    end

    it "destroy the expressions groups" do
      expect(Group.exists?(@groups[0].id)).to be == false
      expect(Group.exists?(@groups[1].id)).to be == false
      expect(Group.exists?(@groups[2].id)).to be == false
    end
  end

  describe "when saving" do
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
