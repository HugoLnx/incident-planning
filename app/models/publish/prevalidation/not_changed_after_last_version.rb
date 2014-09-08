module Publish
  module Prevalidation
    class NotChangedAfterLastVersion
      def self.errors_on(cycle)
        model = Model.from(cycle)
        model.valid?
        model.errors
      end
    end

    class NotChangedAfterLastVersion::Model
      include ActiveModel::Model

      attr_accessor :not_changed_after_last_version

      validates :not_changed_after_last_version,
        truthiness: {message: "You have to issue a version before publish."}

      def self.from(cycle)
        model = self.new
        model.not_changed_after_last_version = !cycle.changed_after_last_version?
        model
      end
    end
  end
end
