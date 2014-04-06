require 'spec_helper'

=begin
  In order to express my consent to an expression
  I want to approve an expression
  As an user
=end

feature "Tactics Matrix: Approving expressions", :js do
  background do
    @user = create :user_god

    DeviseSteps.new(page, routing_helpers).sign_in @user
    @page = AnalysisMatrixPO.new(@user_knowledge)
    @page.visit cycle
  end

  context "Given a cycle with 3 objectives that have no childs" do
    let(:cycle) do
      cycle = create :cycle
      create_list(:objective_group, 3, cycle: cycle)
      cycle
    end

    scenario "I can approve the first objective" do
      cell = @page.cell_of_objective(0)
      metadata_dialog = cell.show_metadata
      @page = metadata_dialog.click_approve

      expect(@page.notice).to have_text "Expression was sucessfuly approved."
      expect(Approval.count).to be == 1

      approvals = Approval.all
      expect(approvals[0].user_role.user).to be == @user
      expect(approvals[0].user_role.role_id).to be == 0
    end
  end

  context "Given a cycle with 1 objetive that have 1 strategy" do
    let(:cycle) do
      cycle = create :cycle
      strategy = create :strategy_group, cycle: cycle
      create(:objective_group, childs: [strategy], cycle: cycle)
      cycle
    end

    scenario "I can approve the how" do
      cell = @page.cell_of_strategy(0, from_objective: 0)
      metadata_dialog = cell.show_metadata
      @page = metadata_dialog.click_approve

      expect(@page.notice).to have_text "Expression was sucessfuly approved."
      expect(Approval.count).to be == 3

      approvals = Approval.all
      expect(approvals[0].user_role.user).to be == @user
      expect(approvals[1].user_role.user).to be == @user
      expect(approvals[2].user_role.user).to be == @user
      expect(approvals[0].user_role.role_id).to be == 0
      expect(approvals[1].user_role.role_id).to be == 1
      expect(approvals[2].user_role.role_id).to be == 2
    end
  end

  context "Given a cycle with 1 objetive that have 1 strategy, that have 1 tactic" do
    let(:cycle) do
      cycle = create :cycle
      tactic = create :tactic_group, cycle: cycle
      strategy = create :strategy_group, childs: [tactic], cycle: cycle
      create(:objective_group, childs: [strategy], cycle: cycle)
      cycle
    end

    shared_examples 'can approve expression' do
      scenario "I can approve that expression" do
        cell = @page.cell_of_tactic_expression(expression_name, from_tactic: 0, from_strategy: 0, from_objective: 0)
        metadata_dialog = cell.show_metadata
        @page = metadata_dialog.click_approve

        expect(@page.notice).to have_text "Expression was sucessfuly approved."
        expect(Approval.count).to be == 3

        approvals = Approval.all
        approvals.each do |approval|
          expect(approval.user_role.user).to be == @user
        end

        expect(approvals[0].user_role.user).to be == @user
        expect(approvals[1].user_role.user).to be == @user
        expect(approvals[2].user_role.user).to be == @user
        expect(approvals[0].user_role.role_id).to be == 1
        expect(approvals[1].user_role.role_id).to be == 2
        expect(approvals[2].user_role.role_id).to be == 3
      end
    end

    context 'who' do
      let(:expression_name) {:who}
      include_examples 'can approve expression'
    end

    context 'what' do
      let(:expression_name) {:what}
      include_examples 'can approve expression'
    end

    context 'where' do
      let(:expression_name) {:where}
      include_examples 'can approve expression'
    end

    context 'when' do
      let(:expression_name) {:when}
      include_examples 'can approve expression'
    end

    context 'response_action' do
      let(:expression_name) {:response_action}
      include_examples 'can approve expression'
    end
  end
end
