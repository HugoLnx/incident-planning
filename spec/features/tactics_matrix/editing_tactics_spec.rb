require 'spec_helper'

=begin
  In order to update my plan
  I want to edit my tactics
  As an user
=end

feature "Tactics Matrix: Editing expressions", :js do
  background do
    user = create :user
    DeviseSteps.new(page, routing_helpers).sign_in user
    @page = AnalysisMatrixPO.new(@user_knowledge)
    @page.visit cycle
  end

  
  shared_examples "edit tactic operations" do
    scenario "I can update the tactic" do
      cell = @page.cell_of_tactic_expression(:who, from_tactic: 0, from_strategy: 0, from_objective: 0)
      form = cell.open_edit_mode

      tactic_wrapper = Groups::Tactic.new(tactic)
      expect(form.get_who_value).to be == tactic_wrapper.who.text
      expect(form.get_what_value).to be == tactic_wrapper.what.text
      expect(form.get_where_value).to be == tactic_wrapper.where.text
      expect(form.get_when_value).to be == tactic_wrapper.when.info_as_str
      expect(form.get_response_action_value).to be == tactic_wrapper.response_action.text

      form.fill_who "New Who"
      form.fill_what "New What"
      form.fill_where "New Where"
      form.fill_when "01/03/2014 09:20"
      form.fill_response_action "New RA"

      new_page = form.press_update

      row = @page.row_of_tactic(0, from_strategy: 0, from_objective: 0)
      expect(row.element).to have_content "New Who"
      expect(row.element).to have_content "New What"
      expect(row.element).to have_content "New Where"
      expect(row.element).to have_content "01/03/2014 09:20"
      expect(row.element).to have_content "New RA"
    end

    scenario "I can delete the tactic" do
      cell = @page.cell_of_tactic_expression(:who, from_tactic: 0, from_strategy: 0, from_objective: 0)
      form = cell.open_edit_mode

      new_page = form.press_delete
      expect(new_page).not_to have_css '.tactic.non-repeated'
    end

    scenario "I can cancel the tactic edition" do
      cell = @page.cell_of_tactic_expression(:who, from_tactic: 0, from_strategy: 0, from_objective: 0)
      form = cell.open_edit_mode

      form.press_cancel
      expect(@page).not_to have_css ".tactic.form"
    end
  end

  context "Given a cycle with 1 objetive that have 1 strategy" do
    background do
      @page.disable_show_metadata
    end

    let(:tactic) {create :tactic_group}
    let(:strategy) {create :strategy_group, childs: [tactic]}
    let(:objective) {create(:objective_group, childs: [strategy])}
    let(:cycle) {create :cycle, groups: [objective]}

    include_examples "edit tactic operations"

    context "After cancel tactic edition and trying to edit again" do
      background do
      cell = @page.cell_of_tactic_expression(:who, from_tactic: 0, from_strategy: 0, from_objective: 0)
        form = cell.open_edit_mode
        form.press_cancel
      end

      include_examples "edit tactic operations"
    end
  end
end

