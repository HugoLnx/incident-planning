module PageObjects
  class AnalysisMatrixRowPO
    attr_reader :element

    def initialize(user, element)
      @user = user
      @element = element
    end

    def press_add_strategy
      @element.click_on "Add Strategy"
      form_element = @element.find "td.strategy.form"
      AnalysisMatrixStrategyFormPO.new(@user, form_element)
    end

    def press_add_tactic
      @element.click_on "Add Tactic"
      form_element = @element.find "td.tactic.who.form"
      AnalysisMatrixTacticFormPO.new(@user, form_element)
    end
  end
end
