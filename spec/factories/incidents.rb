FactoryGirl.define do
  factory :incident do
    sequence(:name){|i| "IncidentName#{i}"}
  end
end
