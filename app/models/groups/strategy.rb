module Groups
  class Strategy
    attr_reader :group

    def initialize(group)
      @group = group
    end

    def group_id
      @group.id
    end

    def how
      @group.text_expressions.find{|exp| exp.name == Model.strategy_how.name}
    end

    def ==(obj)
      return false unless obj.is_a? Strategy
      return obj.group == @group
    end
  end
end
