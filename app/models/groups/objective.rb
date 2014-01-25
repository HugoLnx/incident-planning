module Groups
  class Objective
    def initialize(group)
      @group = group
    end

    def expression
      @group.text_expressions.find{|exp| exp.name == Model.objective.name}
    end
  end
end
