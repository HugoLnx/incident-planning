FactoryGirl.define do
  factory :text_expression do
    text "Expression Text"
    cycle

    factory :objective do
      association :group, factory: :objective_group
      name Model.objective.name
    end

    factory :strategy_how do
      association :group, factory: :strategy_group
      name Model.strategy_how.name
    end

    factory :strategy_why do
      association :group, factory: :strategy_group
      name Model.strategy_why.name
    end

    factory :tactic_who do
      association :group, factory: :tactic_group
      name Model.tactic_who.name
    end

    factory :tactic_what do
      association :group, factory: :tactic_group
      name Model.tactic_what.name
    end

    factory :tactic_where do
      association :group, factory: :tactic_group
      name Model.tactic_where.name
    end

    factory :tactic_when do
      association :group, factory: :tactic_group
      name Model.tactic_when.name
    end

    factory :tactic_response_action do
      association :group, factory: :tactic_group
      name Model.tactic_response_action.name
    end
  end
end
