module PageObjects
  class NewIncidentPO
    def initialize(session, routing_helpers)
      @session = session
      @routing = routing_helpers
    end

    def path
      @routing.new_incident_path
    end

    def visit
      @session.visit path
    end
    
    def incident_form
      form_element = @session.find("#incident_form")
      IncidentFormPO.new(form_element)
    end

    def notice
      @session.find(".notice")
    end
  end
end
