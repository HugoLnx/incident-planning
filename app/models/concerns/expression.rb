module Concerns
  module Expression
    extend ActiveSupport::Concern
    include ApprovalExpertConcern

    SOURCES = TypesLib::Enum.new %w{proposed incident pre_incident}
    STATUS = TypesLib::Enum.new %w{to_be_approved partial_approval approved partial_rejection rejected}

    SOURCES_NAMES = {
      SOURCES.proposed() => "New",
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

      scope :suggested, -> (params) {
        expression_name = params[:expression_name]
        term = params[:term]
        query = self.where({name: expression_name})
        adapter = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
        if adapter == :postgresql
          query = query.where("text ilike ?", "%#{term}%")
        else
          query = query.where("text like ?", "%#{term}%")
        end
        query
      }

      validates_associated :group
      validates_associated :cycle

      validates :name, presence: true
      validates :source, presence: true
      validates :group_id, presence: true
      validates :cycle_id, presence: true
      validates :owner_id, presence: true

      after_initialize :defaults
      around_save :reset_callback, if: :content_changed?

      def status
        roles_needed = roles_needed_to_approve
        if roles_needed.empty?
          return STATUS.approved
        end

        missing_approval = roles_missing_approvement
        if missing_approval.empty?
          if approvals.all?(&:approval?)
            return STATUS.approved
          elsif approvals.all?(&:rejection?)
            return STATUS.rejected
          end
        end

        nobody_approved = missing_approval == roles_needed
        if nobody_approved
          STATUS.to_be_approved
        elsif approvals.any?(&:rejection?)
          STATUS.partial_rejection
        else
          STATUS.partial_approval
        end
      end

      def status_name
        STATUS_NAMES[self.status]
      end

      def source_name
        SOURCES_NAMES[self.source]
      end

      def reset
        self.approvals.destroy_all
        childs = self.group.childs
        while !childs.empty?
          current_group = childs.pop
          childs += current_group.childs
          current_group.text_expressions.includes(:approvals).each{|exp| exp.approvals.destroy_all}
          current_group.time_expressions.includes(:approvals).each{|exp| exp.approvals.destroy_all}
        end
      end

      def expression_model
        ::Model.find_expression_by_name(self.name)
      end

    private
      def defaults
        if !self.persisted?
          self.source ||= 0
        end
      end

      def reset_callback(&block)
        updating = self.persisted?
        yield
        if updating
          reset
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
