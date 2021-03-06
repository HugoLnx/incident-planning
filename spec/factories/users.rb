# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email){|i| "email#{i}@teste.com"}
    name "Name"
    phone "(21)99999-9999"
    password "12341234"
    password_confirmation "12341234"

    factory :user_god do
      after(:create) do |user|
        (0..10).each do |i|
          create :user_role, user: user, role_id: i
          user.reload
        end
      end
    end
  end
end
