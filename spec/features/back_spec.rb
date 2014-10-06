require 'spec_helper'

feature "Back through navigation history" do
  let(:objective) {create(:objective_group)}
  let(:incident) {create :incident}
  let(:cycle) {@cycle}

  background do
    @cycle = create :cycle, groups: [objective], incident: incident
    user = create :user_god
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

    scenario "backing after an user search" do
      page.click_link incident.name
      page.click_link "Search Users"
      visit profiles_path(filter: "filter1")
      visit profiles_path(filter: "filter2", format: :json) # simulating ajax request
      visit profiles_path(filter: "filter2")
      page.click_link "Back"
      expect(current_params[:filter]).to be == "filter1"
    end

    scenario "backing after pdf downloading" do
      page.click_link incident.name

      matrixpo = AnalysisMatrixPO.new(@user_knowledge)
      matrixpo.visit cycle
      matrixpo.print_draft
      matrixpo.visit cycle
      page.click_link "Back"
      expect(current_path).to be == incident_cycles_path(cycle.incident)
    end
  end 
end
