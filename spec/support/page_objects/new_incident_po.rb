module PageObjects
  class NewIncidentPO
    def initialize(session)
      @session = session
    end

    def path
      new_incident_path
    end

    def visit
      @session.visit path
    end
    
    def form
      form_element = @session.find("#incident_form")
      IncidentFormPO.new(form_element)
    end

    def notice
      @session.find(".notice")
    end
  end
end
