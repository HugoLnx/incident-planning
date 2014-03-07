module PageObjects
  class AnalysisMatrixRowPO
    attr_reader :element

    def initialize(element)
      @element = element
    end

    def press_add_strategy
      @element.click_on "ADD STRATEGY"
      form_element = @element.find "td.strategy.form"
      AnalysisMatrixStrategyFormPO.new(form_element)
    end
  end
end
