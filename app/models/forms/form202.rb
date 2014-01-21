module Forms
  class Form202
    include ActiveModel::Model

    attr_accessor :from, :to, :number, :priorities, :incident, :objectives

    def self.model_name
      ActiveModel::Name.new(::Cycle)
    end

    def initialize(*args)
      super
      @cycle = Cycle.new
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

    def save
      begin
        ActiveRecord::Base.transaction do
          cycle.save!
          objectives.each do |objective|
            objective.cycle = cycle
            objective.save!
          end
        end
      rescue ActiveRecord::ActiveRecordError
        return false
      end
      return true
    end
  end
end
