module Publish
  module Prevalidation
    class Permission
      def self.errors_on(user)
        model = Model.from(user)
        model.valid?
        model.errors
      end
    end

    class Permission::Model
      include ActiveModel::Model

      attr_accessor :can_publish

      validates :can_publish,
        truthiness: {message: "Only Incident Commander or Planning Chief can publish."}

      def self.from(user)
        model = self.new
        model.can_publish = user.can_publish?
        model
      end
    end
  end
end
