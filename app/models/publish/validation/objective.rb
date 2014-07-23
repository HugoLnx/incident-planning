module Publish
  module Validation
    class Objective
      include ActiveModel::Model

      attr_accessor :strategies

      validates :strategies,
        not_empty: {message: "Must have at least one strategy."}

      class << self
        def errors_on(group)
          model = from_group(group)
          model.valid?
          model.errors
        end
      private
        def from_group(group)
          objective = self.new
          objective.strategies = group.childs
          objective
        end

      end
    end
  end
end
