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

      attr_accessor :where_text, :expression

      validates :where_text,
        presence: {message: PublishValidation::ITEM_EMPTY_MESSAGE}

      validates :expression,
        approved: true

      def self.from_expression(expression)
        model = self.new
        model.where_text = expression.text
        model.expression = expression
        model
      end
    end
  end
end
