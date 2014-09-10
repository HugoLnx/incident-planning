require 'spec_helper'

feature "Back through navigation history" do
  let(:objective) {create(:objective_group)}
  let(:incident) {create :incident}
  let(:cycle) {@cycle}

  background do
    @cycle = create :cycle, groups: [objective], incident: incident
    user = create :user
    DeviseSteps.new(page, routing_helpers).sign_in user
    page.visit "/"
  end

  context "Common back" do
    scenario "backing from cycle list" do
      page.click_link incident.name
      page.click_link "Back"
      expect(current_path).to be == root_path
    end

    scenario "backing from incident objectives" do
      page.click_link incident.name
      page.click_link "Incident Objectives"
      page.click_link "Back"
      expect(current_path).to be == incident_cycles_path(incident)
    end

    scenario "backing from analysis matrices" do
      page.click_link incident.name
      page.click_link "Work Analysis Matrix"
      page.click_link "Back"
      expect(current_path).to be == incident_cycles_path(incident)
    end

    scenario "backing from My profile" do
      page.click_link incident.name
      page.click_link "My Profile"
      page.click_link "Back"
      expect(current_path).to be == incident_cycles_path(incident)
    end

    scenario "backing from Tool Config" do
      page.click_link incident.name
      page.click_link "Tool Config"
      page.click_link "Back"
      expect(current_path).to be == incident_cycles_path(incident)
    end

    scenario "backing from Search Users" do
      page.click_link incident.name
      page.click_link "Search Users"
      page.click_link "Back"
      expect(current_path).to be == incident_cycles_path(incident)
    end
  end 
end
