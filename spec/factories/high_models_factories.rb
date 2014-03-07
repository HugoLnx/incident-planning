FactoryGirl.define do
  factory :high_models_strategy, class: HighModels::Strategy do
    father_id {create(:objective_group).id}
    cycle_id {create(:cycle).id}
    how "Throwing cleaning products in the sea"
  end

  factory :high_models_tactic, class: HighModels::Tactic do
    father_id {create(:strategy_group).id}
    cycle_id {create(:cycle).id}
    who "The adhesive tape manager"
    what "Put a adhesive tape in the leak point"
    where "Under sea"
    sequence(:when){"22/03/1993 01:30"}
    response_action "petition"
  end
end
