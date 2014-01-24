FactoryGirl.define do
  factory :group do
    cycle
    factory :objective_group do
      name Model.objective.name
    end
  end
end
