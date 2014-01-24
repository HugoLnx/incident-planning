require 'spec_helper'

module Model
  describe Expression do
    it "know your path based on your ancestors names" do
      group_grandfather = build(:model_group, name: "GroupGrandfather")
      group_father = build(:model_group, name: "GroupFather")
      expression = build(:expression, name: "ExpressionChild", father: group_father)

      group_father.father = group_grandfather

      expect(expression.path).to be == "GroupGrandfather/GroupFather/ExpressionChild"
    end
  end
end
