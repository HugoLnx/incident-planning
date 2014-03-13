module PageObjects
  class AnalysisMatrixCellPO
    attr_reader :element

    def initialize(element)
      @element = element
    end

    def double_click
      row_element = @element.find(:xpath, "..")
      @element.native.double_click
      form_element = row_element.find ".strategy.form"
      AnalysisMatrixStrategyFormPO.new(form_element)
    end
  end
end
