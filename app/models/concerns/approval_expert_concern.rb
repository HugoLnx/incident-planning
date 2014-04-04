module Concerns
  module ApprovalExpertConcern
    extend ActiveSupport::Concern

    included do
      extend Forwardable

      def_delegators :@approval_expert,
        :permits_role_approval?,
        :already_had_needed_role_approval?,
        :roles_missing_approvement,
        :roles_needed_to_approve

      after_initialize do |expression|
        @approval_expert = ExpressionApprovalExpert.new(expression)
      end
    end
  end
end
