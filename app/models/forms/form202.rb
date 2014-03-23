module Forms
  class Form202
    include ActiveModel::Model

    attr_accessor :from, :to, :number, :priorities, :incident, :objectives, :objectives_as_str, :cycle

    def self.model_name
      ActiveModel::Name.new(::Cycle)
    end

    def self.new_from(cycle)
      form = self.new
      form.cycle = cycle
      form.from = cycle.from
      form.to = cycle.to
      form.number = cycle.number
      form.priorities = cycle.priorities
      form.incident = cycle.incident
      form.objectives = cycle.text_expressions.objectives.load
      form
    end

    def initialize(*args)
      super
      @cycle = Cycle.new
      @objectives ||= []
    end

    def update_with(params)
      params.each do |key, value|
        if value
          self.public_send(:"#{key}=", value)
        end
      end
    end

    def cycle
      @cycle.from = self.from
      @cycle.to = self.to
      @cycle.number = self.number
      @cycle.incident = self.incident
      @cycle.current_object = "to change"
      @cycle.priorities = self.priorities
      @cycle
    end

    def objectives_text=(objectives_text)
      return if objectives_text.nil?
      @objectives = objectives_text.lines.map do |objective_text|
        TextExpression.new_objective(text: objective_text.strip)
      end
    end

    def objectives_text
      @objectives.map(&:text).join("\n")
    end

    def persisted?
      @cycle.persisted?
    end

    def to_param
      @cycle.to_param
    end

    def save
      begin
        ActiveRecord::Base.transaction do
          cycle.save!
          objectives && objectives.each do |objective|
            objective.cycle = cycle
            Expressions::Objective.save!(objective)
          end
        end
      rescue ActiveRecord::ActiveRecordError
        return false
      end
      return true
    end
  end
end
