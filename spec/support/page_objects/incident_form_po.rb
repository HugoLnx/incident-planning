module PageObjects
  class IncidentFormPO
    def initialize(element)
      @form = element
    end
  
    def fill_name(name)
      @form.fill_in "Name", with: name
    end

    def submit
      @form.click_button "Create incident"
    end
  end
end
