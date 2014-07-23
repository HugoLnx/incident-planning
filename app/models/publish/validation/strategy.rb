module Publish
  module Validation
    class Strategy
      def self.errors_on(group)
        model = Model.from_group(group)
        model.valid?
        model.errors
      end
    end

    class Strategy::Model
      include ActiveModel::Model

      attr_accessor :tactics

      validates :tactics,
        not_empty: {message: "Must have at least one tactic."}

      def self.from_group(group)
        model = self.new
        model.tactics = group.childs
        model
      end
    end
  end
end
