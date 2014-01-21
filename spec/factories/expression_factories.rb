FactoryGirl.define do
  factory :text_expression do
    text "Expression Text"
    cycle

    factory :objective do
      hierarchical_path Model.objective.path
    end
  end
end
