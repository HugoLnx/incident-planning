# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :planning do
    incident_name "MyString"
    priorities_list "MyText"
    from "2014-01-14"
    to "2014-01-14"
    cycle 1
  end
end
