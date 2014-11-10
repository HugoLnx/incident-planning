require 'spec_helper'

=begin
  In order to prepare a plans about the incident
  I want to manage him
  As a Incident Commander
=end

feature "Managing an incident" do
  background do
    user = create :user
    DeviseSteps.new(page, routing_helpers).sign_in user
    @new_incident_page = NewIncidentPO.new(page, routing_helpers)
    @new_incident_page.visit
    @form = @new_incident_page.incident_form
  end

  scenario "Registering an incident" do
    @form.fill_name "Florest is burning"

    expect do
      @form.submit
    end.to change{Incident.count}.by 1

    incident = Incident.last
    expect(incident.name).to be == "Florest is burning"

    expect(@new_incident_page.notice).to have_text "The incident was successfully created."
  end
end
