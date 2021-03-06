FactoryGirl.define do
  factory :time_expression do
    cycle
    reused false
    association :owner, factory: :user
    sequence(:when) {"22/03/1993 10:50"}
    sequence(:source){|i| "Source #{i}"}
    created_at DateTime.now

    factory :tactic_when do
      association :group, factory: :tactic_group
      name Model.tactic_when.name
    end
  end

  factory :text_expression do
    sequence(:text) {|i| "Expression #{name} #{i}"}
    cycle
    association :owner, factory: :user
    sequence(:source){|i| "Source #{i}"}
    created_at DateTime.now

    factory :objective do
      association :group, factory: :objective_group
      name Model.objective.name
    end

    factory :strategy_how do
      association :group, factory: :strategy_group
      name Model.strategy_how.name
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

    factory :tactic_response_action do
      association :group, factory: :tactic_group
      name Model.tactic_response_action.name
    end
  end
end
