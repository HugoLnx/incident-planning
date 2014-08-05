module Publish
  module Validation
    class Where
      def self.errors_on(expression)
        model = Model.from_expression(expression)
        model.valid?
        model.errors
      end
    end

    class Where::Model
      include ActiveModel::Model

      attr_accessor :text, :expression

      validates :text,
        presence: {message: "Item can't be empty."}

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
