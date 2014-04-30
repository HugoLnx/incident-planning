require "spec_helper"

=begin
  In order to declare a new phase of my plan
  I want to create cycles
  As an Incident Commander
=end

feature "Cycles: Creating cycles to an incident" do
  background do
    user = create :user_god
    DeviseSteps.new(page, routing_helpers).sign_in user
    @incident = create :incident
  end

  context "Given the incident haven't any cycles yet" do
    background do
      @page = NewCyclePO.new(@user_knowledge)
      @page.visit @incident
    end

    scenario "I can create the first one" do
      form = @page.form
      expect(form.element).to_not have_button "Copy from previous cycle"

      filled_from = DateTime.new(2014, 5, 27, 10, 30)
      filled_to = filled_from.next_day(1)
      filled_objectives = build_list(:objective, 5)
      filled_priorities = "Priority 1, Priority 2"

      expect do
        form.fill_from filled_from
        form.fill_to filled_to
        form.fill_objectives filled_objectives
        form.fill_priorities filled_priorities
        confirm_page = form.submit

        index_page = confirm_page.click_confirm

        expect(index_page.notice).to have_text "The cycle was successfully registered."
      end.to change{Cycle.count}.by(1)


      cycle = Cycle.last
      expect(cycle.number).to be == 1
      expect(cycle.from).to be == filled_from
      expect(cycle.to).to be == filled_to
      expect(cycle.priorities).to be == filled_priorities
      cycle_texts = cycle.text_expressions.objectives.map(&:text)
      filled_texts = filled_objectives.map(&:text)
      expect(cycle_texts).to be == filled_texts
    end

    scenario "I can cancel the creation on confirmation page" do
      form = @page.form

      filled_from = DateTime.new(2014, 5, 27, 10, 30)
      filled_to = filled_from.next_day(1)
      filled_objectives = build_list(:objective, 5)
      filled_priorities = "Priority 1, Priority 2"

      expect do
        form.fill_from filled_from
        form.fill_to filled_to
        form.fill_objectives filled_objectives
        form.fill_priorities filled_priorities
        confirm_page = form.submit

        @page = confirm_page.click_cancel
      end.to_not change{Cycle.count}

      form = @page.form
      expect(form.number).to be == 1
      expect(form.from).to be == filled_from
      expect(form.to).to be == filled_to
      expect(form.priorities).to be == filled_priorities
      form_texts = form.objectives.map(&:text)
      filled_texts = filled_objectives.map(&:text)
      expect(form_texts).to be == filled_texts
    end
  end

  context "Given the incident have one cycle", :js do
    background do
      create :cycle, incident: @incident
      @page = NewCyclePO.new(@user_knowledge)
      @page.visit @incident
    end

    scenario "I can create another one" do
      form = @page.form
      expect(form.element).to have_button "Copy from previous cycle"

      filled_from = DateTime.new(2014, 5, 27, 10, 30)
      filled_to = filled_from.next_day(1)
      filled_objectives = build_list(:objective, 5)
      filled_priorities = "Priority 1, Priority 2"

      expect do
        form.fill_to filled_to
        form.fill_objectives filled_objectives
        form.fill_priorities filled_priorities
        confirm_page = form.submit

        index_page = confirm_page.click_confirm

        expect(index_page.notice).to have_text "The cycle was successfully registered."
      end.to change{Cycle.count}.by(1)


      cycle = Cycle.last
      expect(cycle.number).to be == 2
      expect(cycle.to).to be == filled_to
      expect(cycle.priorities).to be == filled_priorities
      cycle_texts = cycle.text_expressions.objectives.map(&:text)
      filled_texts = filled_objectives.map(&:text)
      expect(cycle_texts).to be == filled_texts
    end
  end

end
