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

      attr_accessor :strategies

      validates :strategies,
        not_empty: {message: "Must have at least one strategy."}

      def self.from_group(group)
        objective = self.new
        objective.strategies = group.childs
        objective
      end
    end
  end
end
