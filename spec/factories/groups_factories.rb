FactoryGirl.define do
  factory :group do
    factory :objective_group do
      name Model.objective.name
    end
  end
end
