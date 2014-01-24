module Concerns
  module Expression
    extend ActiveSupport::Concern

    included do
      belongs_to :cycle
      belongs_to :group

      has_many :groups, as: :expression

      scope :objectives, -> { where(name: Model.objective.name) }
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
