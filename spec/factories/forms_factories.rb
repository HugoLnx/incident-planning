FactoryGirl.define do
  factory :form202, class: Forms::Form202 do
    from DateTime.now
    to DateTime.now.days_since(1)
    sequence(:number){|i| i}
    objectives %q{
      obj1
      obj2
      obj3
    }
    incident
  end
end
