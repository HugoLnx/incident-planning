module PageObjects
  class AnalysisMatrixStrategyFormPO
    def initialize(input_td)
      @inputs_tr = input_td.find(:xpath, "..")
      @submits_tr = input_td.find(:xpath, "../following-sibling::tr[1]")
    end

    def fill_how(text)
      @inputs_tr.fill_in "strategy[how]", with: text
    end

    def press_create
      @submits_tr.click_on "Create"
    end
  end
end
