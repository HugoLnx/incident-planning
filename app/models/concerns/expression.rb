module Concerns
  module Expression
    extend ActiveSupport::Concern

    included do
      belongs_to :cycle
      belongs_to :group

      scope :objectives, -> { where(name: Model.objective.name) }

      validates_associated :group
      validates_associated :cycle

      validates :name, presence: true
      validates :group_id, presence: true
      validates :cycle_id, presence: true
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
