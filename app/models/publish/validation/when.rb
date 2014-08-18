module Publish
  module Validation
    class When
      def self.errors_on(expression)
        model = Model.from_expression(expression)
        model.valid?
        model.errors
      end
    end

    class When::Model
      include ActiveModel::Model

      attr_accessor :when_text, :expression

      validates :when_text,
        presence: {message: PublishValidation::ITEM_EMPTY_MESSAGE}

      validates :expression,
        approved: true

      def self.from_expression(expression)
        model = self.new
        model.when_text = expression.text
        model.expression = expression
        model
      end
    end
  end
end
