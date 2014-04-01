require 'spec_helper'

=begin
  In order to expand my plan
  I want to create new tactics
  As an user
=end

feature "Tactics Matrix: Adding tactics", :js do
  background do
    user = create :user
    DeviseSteps.new(page, routing_helpers).sign_in user
    @page = AnalysisMatrixPO.new(@user_knowledge)
    @page.visit cycle
  end

  context "Given a cycle with 1 objetive that have 1 strategy" do
    let(:strategy) {create :strategy_group}
    let(:objective) {create :objective_group, childs: [strategy]}
    let(:cycle) {create :cycle, groups: [objective]}

    scenario "I can add a tactic on the strategy" do
      row = @page.row_of_objective(0)
      form = row.press_add_tactic

      form.fill_who "My Who"
      form.fill_what "My What"
      form.fill_where "My Where"
      form.fill_when "01/03/2014 09:20"
      form.fill_response_action "My RA"

      new_page = form.press_create

      row = new_page.row_of_objective(0)
      expect(row.element).to have_content "My Who"
      expect(row.element).to have_content "My What"
      expect(row.element).to have_content "My Where"
      expect(row.element).to have_content "01/03/2014 09:20"
      expect(row.element).to have_content "My RA"
    end
  end
end
