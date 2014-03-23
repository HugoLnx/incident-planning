FactoryGirl.define do
  factory :form202, class: Forms::Form202 do
    from DateTime.now
    to DateTime.now.days_since(1)
    sequence(:number){|i| i}
    incident
    objectives nil
    objectives_text nil
    association(:owner, factory: :user)
  end
end
