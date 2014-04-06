require 'spec_helper'

module Model
  describe ExpressionParser do
    context "when parsing a single hash" do
      it "create an expression extracting name, type, optionality and approval roles" do
        hash = {
          "name" => "ExpressionName",
          "type" => "time",
          "optional" => true,
          "approval-roles" => %w{Role1 Role2},
          "creator-roles" => %w{Role3 Role4}
        }

        parser = build :expression_parser
        expression = parser.parse hash

        expect(expression.name).to be == "ExpressionName"
        expect(expression.type).to be == Expression::TYPES.time
        expect(expression.optional).to be == true
        expect(expression.approval_roles).to be == %w{Role1 Role2}
        expect(expression.creator_roles).to be == %w{Role3 Role4}
      end

      context 'when type key does not exist in hash' do
        it "sets expression type to text" do
          hash = build :expression_parse_params, type: nil

          parser = build :expression_parser
          expression = parser.parse hash

          expect(expression.type).to be == Expression::TYPES.text
        end
      end
    end

    context "when parsing an array of hashes" do
      it "maps to an array of expressions" do
        hash = [
          {"name" => "Expression1"},
          {"name" => "Expression2"}
        ]

        parser = build :expression_parser
        expressions = parser.parse_all hash

        expect(expressions[0].name).to be == "Expression1"
        expect(expressions[1].name).to be == "Expression2"
      end

      it "sets the expressions fathers" do
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
end
