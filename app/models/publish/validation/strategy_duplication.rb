module Publish
  module Validation
    class StrategyDuplication
      ERROR_MESSAGE = "The same objective can't have duplicated strategies."

      def self.errors_on(strategy, all_objectives)
        father = all_objectives.find{|obj| obj == strategy.father}
        siblings = father.childs.to_a
        instances_count = siblings.count{|sibling| strategy.duplication?(sibling)}

        errors = ActiveModel::Errors.new(nil)
        if instances_count > 1
          errors.add(:strategy, ERROR_MESSAGE)
        end
        errors
      end
    end
  end
end
