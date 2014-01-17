FactoryGirl.define do
  factory :group, class: Model::Group do
    ignore do
      sequence(:name){|i| "GroupName #{i}"}
    end

    initialize_with{ new(name)}
  end

  factory :expression, class: Model::Expression do
    ignore do
      sequence(:name){|i| "ExpressionName #{i}"}
      sequence(:type){|i| Model::Expression::TYPES.sample}
      sequence(:optional){|i| [true, false].sample}
      approval_roles "Chief"
      father nil
    end

    initialize_with{ new(name, type, optional, approval_roles, father) }
  end

  factory :expression_parser, class: Model::ExpressionParser do
    initialize_with{ new() }
  end

  factory :group_parser, class: Model::GroupParser do
    ignore do
      expression_parser{build :expression_parser}
    end
    initialize_with{ new(expression_parser) }
  end
end
