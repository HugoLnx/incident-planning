require 'spec_helper'

module Model
  describe ExpressionParser do
    it "parse hash with a named expression" do
      hash = {
        "name" => "ExpressionName"
      }

      parser = ExpressionParser.new
      expression = parser.parse hash

      expect(expression.name).to be == "ExpressionName"
    end

    it "parse expression type" do
      hash = {
        "type" => "Type"
      }

      parser = ExpressionParser.new
      expression = parser.parse hash

      expect(expression.type).to be == "Type"
    end

    it "parse expression optionality" do
      hash = {
        "optional" => true
      }

      parser = ExpressionParser.new
      expression = parser.parse hash

      expect(expression.optional).to be == true
    end

    it "parse expression approval roles" do
      hash = {
        "approval-roles" => %w{Role1 Role2}
      }

      parser = ExpressionParser.new
      expression = parser.parse hash

      expect(expression.approval_roles).to be == %w{Role1 Role2}
    end

    it "parse an array of expressions" do
      hash = [
        {"name" => "Expression1"},
        {"name" => "Expression2"},
      ]

      parser = ExpressionParser.new
      expressions = parser.parse_all hash

      expect(expressions[0].name).to be == "Expression1"
      expect(expressions[1].name).to be == "Expression2"
    end
  end
end
