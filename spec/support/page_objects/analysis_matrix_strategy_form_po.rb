module PageObjects
  class AnalysisMatrixStrategyFormPO
    def initialize(user, input_td)
      @user = user
      @inputs_tr = input_td.find(:xpath, "..")
      @submits_tr = input_td.find(:xpath, "../following-sibling::tr[1]")
    end

    def fill_how(text)
      @inputs_tr.fill_in "strategy[how]", with: text
    end

    def press_create
      how_value = @inputs_tr.find(:xpath, ".//*[@name='strategy[how]']").value
      @submits_tr.click_on "Create"
      wait_until{@user.session.has_text? how_value}
      AnalysisMatrixPO.new(@user)
    end

    def press_update
      how_value = @inputs_tr.find(:xpath, ".//*[@name='strategy[how]']").value
      @submits_tr.click_on "Update"
      wait_until{@user.session.has_text? how_value}
      AnalysisMatrixPO.new(@user)
    end

    def press_delete
      @submits_tr.click_on "Delete"
      wait_until{@user.session.has_no_css? ".strategy.form"}
      AnalysisMatrixPO.new(@user)
    end

    def press_cancel
      @submits_tr.click_on "Cancel"
    end
  end
end
