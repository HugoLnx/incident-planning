require 'spec_helper'

=begin
  In order to expand my plan
  I want to manage strategies and tactics
  As an user
=end

feature "Analysis Matrix basic operations", :js do
  background do
    @page = AnalysisMatrixPO.new(page, routing_helpers)
    @page.visit cycle
  end

  context "Given a cycle with 3 objetives that have no childs" do
    let(:cycle) do
      create :cycle,
        groups: create_list(:objective_group, 3)
    end

    scenario "I can add a strategy on the first objective" do
      pg = page
      row = @page.row_of_objective(0)
      form = row.press_add_strategy

      form.fill_how "My How"
      form.press_create

      wait_until{page.body.match "My How"}

      row = @page.row_of_objective(0)
      expect(row.element).to have_content "My How"
    end
  end

  context "Given a cycle with 1 objetive that have 1 strategy" do
    let(:cycle) do
      objective = create(:objective_group,
         childs: create_list(:strategy_group, 1))
      create :cycle,
        groups: [objective]
    end

    scenario "I can update the strategy" do
      cell = @page.cell_of_strategy(0, from_objective: 0)
      form = cell.double_click

      form.fill_how "New How"
      form.press_update

      wait_until{page.body.match "New How"}

      cell = @page.cell_of_strategy(0, from_objective: 0)
      expect(cell.element).to have_content "New How"
    end
  end
end
