module PageObjects
  class AnalysisMatrixRowPO
    attr_reader :element

    def initialize(user, element)
      @user = user
      @element = element
    end

    def press_add_strategy
      @element.click_on "ADD STRATEGY"
      form_element = @element.find "td.strategy.form"
      AnalysisMatrixStrategyFormPO.new(@user, form_element)
    end
  end
end
