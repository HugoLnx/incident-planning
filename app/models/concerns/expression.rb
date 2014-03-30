module Concerns
  module Expression
    extend ActiveSupport::Concern

    SOURCES = TypesLib::Enum.new %w{proposed incident pre_incident}
    STATUS = TypesLib::Enum.new %w{to_be_approved partial_approval approved partial_rejection rejected}

    SOURCES_NAMES = {
      SOURCES.proposed() => "Proposed",
      SOURCES.incident() => "Incident",
      SOURCES.pre_incident() => "Pre Incident"
    }

    STATUS_NAMES = {
      STATUS.to_be_approved() => "To Be Approved",
      STATUS.partial_approval() => "Partial Approval",
      STATUS.approved() => "Approved",
      STATUS.partial_rejection() => "Partial Rejection",
      STATUS.rejected() => "Rejected"
    }

    included do
      belongs_to :cycle
      belongs_to :group
      belongs_to :owner, class_name: "User"

      has_many :approvals, as: :expression

      scope :objectives, -> { where(name: Model.objective.name) }

      validates_associated :group
      validates_associated :cycle

      validates :name, presence: true
      validates :source, presence: true
      validates :group_id, presence: true
      validates :cycle_id, presence: true
      validates :owner_id, presence: true

      after_initialize :defaults

      def status
        STATUS.to_be_approved()
      end

      def status_name
        STATUS_NAMES[self.status]
      end

      def source_name
        SOURCES_NAMES[self.source]
      end

      def permits_role_approval?(roles_ids=[])
        if roles_ids.is_a? Fixnum
          roles_ids = [roles_ids]
        end
        !(roles_needed_to_approve & roles_ids).empty?
      end

      def already_had_needed_role_approval?(roles_ids=[])
        permitted_roles = roles_ids & roles_needed_to_approve
        return false if permitted_roles.empty?

        approving_roles = self.approvals.map{|a| a.user_role.role_id}
        (permitted_roles - approving_roles).empty?
      end

      def roles_missing_approvement
        approving_roles = self.approvals.map{|a| a.user_role.role_id}
        roles_needed_to_approve - approving_roles
      end

      def roles_needed_to_approve
        expression_model = ::Model.find_expression_by_name(self.name)
        expression_model.approval_roles
      end

      def user_that_approved_as(role_id)
        approval = self.approvals.joins(:user_role).where('user_roles.role_id' => role_id).first
        approval && approval.user_role.user
      end

    private
      def defaults
        if !self.persisted?
          self.source ||= 0
        end
      end
    end

    module ClassMethods
      def new_objective(*args)
        expression = self.new(*args)
        expression.name = Model.objective.name
        expression
      end
    end
  end
end
