module Publish
  module Validation
    class ResponseAction
      def self.errors_on(expression)
        model = Model.from_expression(expression)
        model.valid?
        model.errors
      end
    end

    class ResponseAction::Model
      include ActiveModel::Model

      attr_accessor :expression

      validates :expression,
        approved: true

      def self.from_expression(expression)
        model = self.new
        model.expression = expression
        model
      end
    end
  end
end
