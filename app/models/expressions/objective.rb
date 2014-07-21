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

    def self.destroy(objectives)
      ActiveRecord::Base.transaction do
        objectives.each do |obj|
          obj.group.reload
          obj.group.destroy
        end
      end
    end
  end
end
