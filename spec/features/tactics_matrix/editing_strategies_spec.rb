require 'spec_helper'

=begin
  In order to update my plan
  I want to edit my strategies
  As an user
=end

feature "Tactics Matrix: Editing expressions", :js do
  background do
    user = create :user_god
    DeviseSteps.new(page, routing_helpers).sign_in user
    @page = AnalysisMatrixPO.new(@user_knowledge)
    @page.visit cycle
  end

  
  shared_examples "edit strategy operations" do
    scenario "I can update the strategy" do
      cell = @page.cell_of_strategy(0, from_objective: 0)
      form = cell.open_edit_mode
      expect(form.get_how_value).to be == Groups::Strategy.new(strategy).how.text

      form.fill_how "New How"
      new_page = form.press_update

      cell = new_page.cell_of_strategy(0, from_objective: 0)
      expect(cell.element).to have_content "New How"
    end

    scenario "I can delete the strategy" do
      cell = @page.cell_of_strategy(0, from_objective: 0)
      form = cell.open_edit_mode

      new_page = form.press_delete
      expect(new_page).not_to have_content Groups::Strategy.new(strategy).how.text
    end

    scenario "I can cancel the strategy edition" do
      cell = @page.cell_of_strategy(0, from_objective: 0)
      form = cell.open_edit_mode

      form.press_cancel
      expect(@page).not_to have_css ".strategy.form"
    end
  end

  context "Given a cycle with 1 objetive that have 1 strategy" do
    background do
      @page.disable_show_metadata
    end

    let(:strategy) {create :strategy_group}
    let(:objective) {create(:objective_group, childs: [strategy])}
    let(:cycle) {create :cycle, groups: [objective]}

    include_examples "edit strategy operations"

    context "After cancel strategy edition and trying to edit again" do
      background do
        cell = @page.cell_of_strategy(0, from_objective: 0)
        form = cell.open_edit_mode
        form.press_cancel
      end

      include_examples "edit strategy operations"
    end
  end
end
