module Groups
  class Objective
    attr_reader :group

    def initialize(group)
      @group = group
    end

    def expression
      @group.text_expressions.find{|exp| exp.name == Model.objective.name}
    end

    def ==(obj)
      return false unless obj.is_a? Objective
      return obj.group == @group
    end
  end
end
