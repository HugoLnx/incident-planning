module PageObjects
  class CyclesIndexPO
    def initialize(user_knowledge)
      @user = user_knowledge
      @session = user_knowledge.session
      @routing = user_knowledge.routing
    end

    def path(incident)
      @routing.incident_cycles_path(incident)
    end

    def visit(incident)
      @session.visit path(incident)
    end

    def notice
      @session.find(".notice")
    end
  end
end
