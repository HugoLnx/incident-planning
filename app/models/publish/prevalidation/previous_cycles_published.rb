module Publish
  module Prevalidation
    class PreviousCyclesPublished
      def self.errors_on(cycle)
        model = Model.from(cycle)
        model.valid?
        model.errors
      end
    end

    class PreviousCyclesPublished::Model
      include ActiveModel::Model

      attr_accessor :next_to_be_published

      validates :next_to_be_published,
        truthiness: {message: "All previous cycles must be published."}

      def self.from(cycle)
        model = self.new
        model.next_to_be_published = cycle.next_to_be_published?
        model
      end
    end
  end
end
