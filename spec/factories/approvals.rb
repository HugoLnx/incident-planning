# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :approval do
    user_role
    association(:expression, factory: :objective)
  end
end