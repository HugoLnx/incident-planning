# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cycle do
    incident
    number 1
    current_object 1
    from "2014-01-17"
    to "2014-01-17"
    closed false
    priorities_approval_status false
    priorities "Default priorities"
    groups []
  end
end
