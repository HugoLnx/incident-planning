module Publish
  module Validation
    class Who
      def self.errors_on(expression)
        model = Model.from_expression(expression)
        model.valid?
        model.errors
      end
    end

    class Who::Model
      include ActiveModel::Model

      attr_accessor :text, :expression

      validates :text,
        presence: {message: "must be present."}

      validates :expression,
        approved: true

      def self.from_expression(expression)
        model = self.new
        model.text = expression.text
        model.expression = expression
        model
      end
    end
  end
end
