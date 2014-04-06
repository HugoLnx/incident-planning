FactoryGirl.define do
  factory :model_group, class: Model::Group do
    ignore do
      sequence(:name){|i| "GroupName #{i}"}
      creator_roles [0, 1]
    end

    initialize_with{new(name, creator_roles)}
  end

  factory :expression, class: Model::Expression do
    ignore do
      sequence(:name){|i| "ExpressionName #{i}"}
      type Model::Expression::TYPES.time
      sequence(:optional){|i| [true, false].sample}
      approval_roles [0]
      father nil
    end

    initialize_with{ new(name, type, optional, approval_roles, father) }
  end

  factory :expression_parser, class: Model::ExpressionParser do
    initialize_with{ new() }
  end

  factory :expression_parse_params, class: Hash do
    ignore do
      sequence(:name){|i| "ExpressionName#{i}"}
      type Model::Expression::TYPES.time
      optional true
      approval_roles %w{Role1 Role2}
    end

    initialize_with do
      {
        "name" => name,
        "type" => type,
        "optional" => optional,
        "approval-roles" => approval_roles
      }
    end
  end

  factory :group_parser, class: Model::GroupParser do
    ignore do
      expression_parser{build :expression_parser}
    end
    initialize_with{ new(expression_parser) }
  end
end
