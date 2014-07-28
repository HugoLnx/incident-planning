module Publish
  module Validation
    class Objective
      def self.errors_on(group)
        model = Model.from_group(group)
        model.valid?
        model.errors
      end
    end

    class Objective::Model
      include ActiveModel::Model

      attr_accessor :strategies, :objective

      validates :strategies,
        not_empty: {message: "must have at least one strategy."}

      validates :objective,
        approved: true

      def self.from_group(group)
        objective = self.new
        objective.strategies = group.childs
        objective.objective = group.text_expressions.first
        objective
      end
    end
  end
end
