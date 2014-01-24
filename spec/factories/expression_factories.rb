FactoryGirl.define do
  factory :text_expression do
    text "Expression Text"
    cycle

    factory :objective do
      association :group, factory: :objective_group
      name Model.objective.name
    end
  end
end
