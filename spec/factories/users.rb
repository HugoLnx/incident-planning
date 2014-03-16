# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email){|i| "email#{i}@teste.com"}
    password "12341234"
    password_confirmation "12341234"
  end
end
