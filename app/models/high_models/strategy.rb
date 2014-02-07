module HighModels
  class Strategy
    include ActiveModel::Model

    attr_accessor :father_id, :cycle_id, :how, :why
    attr_reader :group

    validates :father_id, presence: true

    validates :how, presence: true

    def initialize(*args)
      @group = ::Group.new
      @group.name = ::Model.strategy.name
      super
    end

    def group
      @group.father_id = father_id
      @group.cycle_id = cycle_id
      @group
    end

    def how=(text)
      if text
        @how = ::TextExpression.new(name: Model.strategy_how.name, text: text)
      else
        @how = nil
      end
    end

    def why=(text)
      if text
        @why = ::TextExpression.new(name: Model.strategy_why.name, text: text)
      else
        @why = nil
      end
    end

    def how
      @how && @how.cycle_id = cycle_id
      @how
    end

    def why
      @why && @why.cycle_id = cycle_id
      @why
    end

    def associations_valid?
      valid? && group.valid? && (why.nil? || why.valid?) && (how.nil? || how.valid?)
    end

    def errors
      my_errors = super
      group.errors.each{|name, msg| my_errors.add(name, msg)}
      how && how.errors.each{|name, msg| my_errors.add(name, msg)}
      why && why.errors.each{|name, msg| my_errors.add(name, msg)}
      my_errors
    end

    def save
      begin
        return false unless valid?
        ActiveRecord::Base.transaction do
          group.save!
          if how
            how.group = group
            how.save!
          end
          if why
            why.group = group
            why.save!
          end
        end
        return true
      rescue ActiveRecord::ActiveRecordError
        return false
      end
    end

  end
end
