FactoryGirl.define do
  factory :form202, class: Forms::Form202 do
    from DateTime.now
    to DateTime.now.days_since(1)
    sequence(:number){|i| i}
    incident
    association(:owner, factory: :user)
    ignore do
      objectives nil
      objectives_texts []
    end

    initialize_with do
      params = {}
      if objectives.nil?
        params[:objectives_texts] = objectives_texts
      else
        params[:objectives] = objectives
      end
      new(params)
    end
  end
end
