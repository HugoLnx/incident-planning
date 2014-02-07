FactoryGirl.define do
  factory :high_models_strategy, class: HighModels::Strategy do
    father_id {create(:objective_group).id}
    cycle_id {create(:cycle).id}
    how "Throwing cleaning products in the sea"
    why "To clean the sea"
  end
end
