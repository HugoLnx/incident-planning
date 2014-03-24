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

      def needs_role_approval?(roles_ids=[])
        if roles_ids.is_a? Fixnum
          roles_ids = [roles_ids]
        end
        expression_model = ::Model.find_expression_by_name(self.name)
        expression_model.approval_roles.any?{|approval_role| roles_ids.include? approval_role}
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
