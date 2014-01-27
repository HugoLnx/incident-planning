FactoryGirl.define do
  factory :analysis_matrix_data do
    ignore do
      objectives []
    end

    initialize_with{ new(objectives)}
  end
end
