require 'spec_helper'

=begin
  In order to expand my plan
  I want to manage strategies and tactics
  As an user
=end

feature "Analysis Matrix basic operations", :js do
  background do
    @cycle = create :cycle,
      groups: create_list(:objective_group, 3)
    @page = AnalysisMatrixPO.new(page, routing_helpers)
    @page.visit @cycle
  end

  scenario "Adding a strategy on objective with no childs" do
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
