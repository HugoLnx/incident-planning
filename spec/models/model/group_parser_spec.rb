require "spec_helper"

module Model
  describe GroupParser do
    it "parse hash with a named group" do
      hash = {"group" => {"name" => "GroupName"}}

      parser = GroupParser.new ExpressionParser.new
      group = parser.parse hash
      expect(group.name).to be == "GroupName"
    end

    it "parse hash with a chain of groups" do
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

      parser = GroupParser.new ExpressionParser.new
      group = parser.parse hash

      expect(group.name).to be == "GroupRoot"
      expect(group.child.name).to be == "GroupChild"
      expect(group.child.child.name).to be == "GroupGrandchild"
    end

    it "parse hash with a group and your expressions" do
      hash = {
        "group" => {
          "name" => "GroupName",
          "expressions" => [
            {"name" => "ExpressionName"}
          ]
        }
      }

      
      parser = GroupParser.new ExpressionParser.new
      group = parser.parse hash
      expect(group.expressions.first.name).to be == "ExpressionName"
    end

  end
end
