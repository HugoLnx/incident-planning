require 'spec_helper'

=begin
  In order to expand my plan
  I want to manage strategies and tactics
  As an user
=end

feature "Analysis Matrix basic operations", :js do
  background do
    user = create :user
    DeviseSteps.new(page, routing_helpers).sign_in user
    @page = AnalysisMatrixPO.new(@user_knowledge)
    @page.visit cycle
  end

  context "Given a cycle with 3 objetives that have no childs" do
    let(:cycle) do
      create :cycle,
        groups: create_list(:objective_group, 3)
    end

    scenario "I can add a strategy on the first objective" do
      row = @page.row_of_objective(0)
      form = row.press_add_strategy

      form.fill_how "My How"
      new_page = form.press_create

      row = new_page.row_of_objective(0)
      expect(row.element).to have_content "My How"
    end
  end
  
  shared_examples "edit strategy operations" do
    scenario "I can update the strategy" do
      cell = @page.cell_of_strategy(0, from_objective: 0)
      form = cell.double_click
      expect(form.get_how_value).to be == Groups::Strategy.new(strategy).how.text

      form.fill_how "New How"
      new_page = form.press_update

      cell = new_page.cell_of_strategy(0, from_objective: 0)
      expect(cell.element).to have_content "New How"
    end

    scenario "I can delete the strategy" do
      cell = @page.cell_of_strategy(0, from_objective: 0)
      form = cell.double_click

      new_page = form.press_delete
      expect(new_page).not_to have_content Groups::Strategy.new(strategy).how.text
    end

    scenario "I can cancel the strategy edition" do
      cell = @page.cell_of_strategy(0, from_objective: 0)
      form = cell.double_click

      form.press_cancel
      expect(@page).not_to have_css ".strategy.form"
    end
  end

  context "Given a cycle with 1 objetive that have 1 strategy" do
    let(:strategy) {create :strategy_group}
    let(:objective) {create(:objective_group, childs: [strategy])}
    let(:cycle) {create :cycle, groups: [objective]}

    include_examples "edit strategy operations"

    context "After cancel strategy edition and trying to edit again" do
      background do
        cell = @page.cell_of_strategy(0, from_objective: 0)
        form = cell.double_click
        form.press_cancel
      end

      include_examples "edit strategy operations"
    end
  end
end
