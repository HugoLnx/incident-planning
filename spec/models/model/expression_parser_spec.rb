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
