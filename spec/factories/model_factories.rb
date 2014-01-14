FactoryGirl.define do
  factory :group, class: Model::Group do
    ignore do
      sequence(:name){|i| "GroupName #{i}"}
    end

    initialize_with{ new(name, nil)}
  end
end
