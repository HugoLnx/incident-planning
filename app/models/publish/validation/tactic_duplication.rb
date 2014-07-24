module Publish
  module Validation
    class TacticDuplication
      ERROR_MESSAGE = "The same strategy can't have two tactics with same who, what and where."

      def self.group_errors_on(tactic, all_strategies)
        father = all_strategies.find{|strat| strat == tactic.father}
        siblings = father.childs.to_a
        instances_count = siblings.count{|sibling| tactic.duplication?(sibling)}

        errors = ActiveModel::Errors.new(nil)
        if instances_count > 1
          errors.add(:who_what_where, ERROR_MESSAGE)
        end
        errors
      end
    end
  end
end
