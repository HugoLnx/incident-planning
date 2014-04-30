# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :approval do
    user{create :user_god}
    role_id 1
    positive true
    association(:expression, factory: :objective)
  end
end
