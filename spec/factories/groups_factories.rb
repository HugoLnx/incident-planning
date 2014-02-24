FactoryGirl.define do
  factory :group do
    cycle
    name "group name"
    childs []
    ignore do
      text_expressions []
    end
    father nil

    initialize_with do
      children = childs
      children ||= []

      obj = new(attributes)
      children.each do |child|
        child.father = obj
      end
      obj
    end

    after :create do |group, evaluator|
      group.text_expressions = evaluator.text_expressions
      evaluator.text_expressions.each do |expression|
        expression.group_id = group.id
        expression.cycle_id = group.cycle_id
      end
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
