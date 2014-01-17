require 'spec_helper'

=begin
  To prepare a plans about the incident
  I want to manage him
  As a Incident Commander
=end

feature "Managing an incident" do
  scenario "Registering an incident" do
    @new_incident_page = NewIncidentPO.new(page)
    @new_incident_page.visit
    
    form = @new_incident_page.incident_form
    form.fill_name "Florest is burning"
    form.submit

    expect(@new_incident_page.notice).to have_text "The incident was successfully registered."
  end
end
