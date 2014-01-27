FactoryGirl.define do
  factory :group do
    cycle
    childs []
    father nil

    initialize_with do
      children = childs
      children ||= []

      obj = new(childs: childs)
      children.each do |child|
        child.father = obj
      end
      obj
    end

    factory :objective_group do
      name Model.objective.name
    end

    factory :strategy_group do
      name Model.strategy.name
    end

    factory :tactic_group do
      name Model.tactic.name
    end
  end
end
