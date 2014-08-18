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
      attr_accessor :how
      attr_accessor :text

      validates :tactics,
        not_empty: {message: "Must have at least one tactic."}

      validates :text,
        presence: {message: PublishValidation::ITEM_EMPTY_MESSAGE}

      validates :how,
        approved: true

      def self.from_group(group)
        model = self.new
        model.tactics = group.childs
        model.how = group.text_expressions.first
        model.text = model.how.text
        model
      end
    end
  end
end
