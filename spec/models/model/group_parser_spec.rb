require "spec_helper"

module Model
  describe GroupParser do
    it "parse hash with a named group" do
      hash = {"group" => {"name" => "GroupName"}}

      parser = build :group_parser
      group = parser.parse hash
      expect(group.name).to be == "GroupName"
    end

    context "hash with a chain of groups" do
      before :each do
        hash = {
          "group" => {
            "name" => "GroupRoot",
            "group" => {
              "name" => "GroupChild",
              "group" => {
                "name" => "GroupGrandchild"
              }
            }
          }
        }

        parser = build :group_parser
        @group = parser.parse hash
      end

      it "parse relating as childs" do
        expect(@group.name).to be == "GroupRoot"
        expect(@group.child.name).to be == "GroupChild"
        expect(@group.child.child.name).to be == "GroupGrandchild"
      end

      it "parse relating as fathers" do
        father = @group
        child = @group.child
        grandchild = @group.child.child

        expect(grandchild.father).to be == child
        expect(child.father).to be == father
        expect(father.father).to be == nil
      end
    end

    context "hash with a group and your expressions" do
      before :each do
        hash = {
          "group" => {
            "name" => "GroupName",
            "expressions" => [
              {"name" => "ExpressionName"}
            ]
          }
        }
        
        parser = build :group_parser
        @group = parser.parse hash
      end

      it "parse the expressions" do
        expect(@group.expressions.first.name).to be == "ExpressionName"
      end

      it "relate expressions to the group as their father" do
        expect(@group.expressions.first.father).to be == @group
      end
    end
  end
end
