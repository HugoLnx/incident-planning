module Groups
  class Tactic
    attr_reader :group

    def initialize(group)
      @group = group
    end

    def who
      @group.text_expressions.find{|exp| exp.name == Model.tactic_who.name}
    end

    def what
      @group.text_expressions.find{|exp| exp.name == Model.tactic_what.name}
    end

    def where
      @group.text_expressions.find{|exp| exp.name == Model.tactic_where.name}
    end

    def when
      @group.time_expressions.find{|exp| exp.name == Model.tactic_when.name}
    end

    def response_action
      @group.text_expressions.find{|exp| exp.name == Model.tactic_response_action.name}
    end

    def ==(obj)
      return false unless obj.is_a? Tactic
      return obj.group == @group
    end
  end
end
