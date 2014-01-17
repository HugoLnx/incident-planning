require 'spec_helper'

module Model
  describe ExpressionParser do
    it "parse hash with a named expression" do
      hash = {
        "name" => "ExpressionName"
      }

      parser = build :expression_parser
      expression = parser.parse hash

      expect(expression.name).to be == "ExpressionName"
    end

    it "parse expression type" do
      hash = {
        "type" => "Type"
      }

      parser = build :expression_parser
      expression = parser.parse hash

      expect(expression.type).to be == "Type"
    end

    it "parse expression optionality" do
      hash = {
        "optional" => true
      }

      parser = build :expression_parser
      expression = parser.parse hash

      expect(expression.optional).to be == true
    end

    it "parse expression approval roles" do
      hash = {
        "approval-roles" => %w{Role1 Role2}
      }

      parser = build :expression_parser
      expression = parser.parse hash

      expect(expression.approval_roles).to be == %w{Role1 Role2}
    end

    it "parse an array of expressions" do
      hash = [
        {"name" => "Expression1"},
        {"name" => "Expression2"}
      ]

      parser = build :expression_parser
      expressions = parser.parse_all hash

      expect(expressions[0].name).to be == "Expression1"
      expect(expressions[1].name).to be == "Expression2"
    end

    it "parse an array of expressions including the father" do
      hash = [
        {"name" => "Expression1"},
        {"name" => "Expression2"}
      ]

      parser = build :expression_parser
      father = build :group
      expressions = parser.parse_all hash, father

      expect(expressions).to be_all{|e| e.father == father}
    end
  end
end
