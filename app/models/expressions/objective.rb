module Expressions
  class Objective
    def self.save!(objective)
      if objective.group
        group = objective.group
      else
        group = Group.new name: Model.objective.name
      end

      group.cycle = objective.cycle
      group.save!
      objective.group = group
      objective.save!
    end
  end
end
