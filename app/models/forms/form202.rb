module Forms
  class Form202
    include ActiveModel::Model

    attr_accessor :from, :to, :number, :incident

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
      @cycle
    end

    def save
      begin
        ActiveRecord::Base.transaction do
          cycle.save!
        end
      rescue ActiveRecord::ActiveRecordError
        return false
      end
      return true
    end
  end
end
