module PageObjects
  class CycleConfirmPO
    def initialize(user_knowledge)
      @user = user_knowledge
      @session = user_knowledge.session
      @routing = user_knowledge.routing
    end

    def path(incident, cycle_attributes)
      @routing.incident_confirm_cycle_path(incident, cycle_attributes)
    end

    def visit(incident, cycle_attributes)
      @session.visit path(incident, cycle_attributes)
    end

    def click_confirm
      @session.click_button "Confirm"
      wait_until{!@session.current_path.include?("confirm")}
      CyclesIndexPO.new(@user)
    end

    def click_cancel
      @session.click_button "Cancel"
      wait_until{!@session.current_path.include?("confirm")}
      NewCyclePO.new(@user)
    end
  end
end

