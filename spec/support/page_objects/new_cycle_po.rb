module PageObjects
  class NewCyclePO
    def initialize(user_knowledge)
      @user = user_knowledge
      @session = user_knowledge.session
      @routing = user_knowledge.routing
    end

    def path(incident)
      @routing.new_incident_cycle_path(incident)
    end

    def visit(incident)
      @session.visit path(incident)
    end

    def form
      form_element = @session.find "#new_cycle"
      PageObjects::NewCycleFormPO.new(@user, form_element)
    end
  end
end

