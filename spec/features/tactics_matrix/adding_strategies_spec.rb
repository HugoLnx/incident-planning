require 'spec_helper'

=begin
  In order to expand my plan
  I want to create new strategies
  As an user
=end

feature "Tactics Matrix: Adding strategies", :js do
  background do
    user = create :user_god
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
end
