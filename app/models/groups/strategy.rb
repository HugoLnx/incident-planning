module Groups
  class Strategy
    def initialize(group)
      @group = group
    end

    def how
      @group.text_expressions.find{|exp| exp.name == Model.strategy_how.name}
    end

    def why
      @group.text_expressions.find{|exp| exp.name == Model.strategy_why.name}
    end
  end
end
