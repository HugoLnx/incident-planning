FactoryGirl.define do
  factory :group do
    cycle
    name "group name"
    childs []
    ignore do
      text_expressions []
      time_expressions []
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
      [:text_expressions, :time_expressions].each do |attr|
        group.public_send(:"#{attr}=", evaluator.public_send(attr))
        evaluator.public_send(attr).each do |expression|
          expression.group_id = group.id
          expression.cycle_id = group.cycle_id
          expression.save
        end
      end
    end

    factory :objective_group do
      name Model.objective.name
      text_expressions{[build(:objective, group: nil)]}
    end

    factory :strategy_group do
      name Model.strategy.name
      association :father, factory: :objective_group
      text_expressions{[build(:strategy_how, group: nil)]}
    end

    factory :tactic_group do
      name Model.tactic.name
      association :father, factory: :strategy_group
      text_expressions{[
        build(:tactic_who, group: nil),
        build(:tactic_what, group: nil),
        build(:tactic_where, group: nil),
        build(:tactic_response_action, group: nil)
      ]}
      time_expressions{[
        build(:tactic_when, group: nil)
      ]}
    end
  end
end
