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

    describe "when getting your pretty name uses the real name as base" do
      it "downcase the real name" do
        expression = build(:expression, name: "ExpName")
        expect(expression.pretty_name).to be == "expname"
      end

      it "replaces white spaces to underscores" do
        expression = build(:expression, name: "Exp Name")
        expect(expression.pretty_name).to be == "exp_name"
      end
    end
  end
end
