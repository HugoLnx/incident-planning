module PageObjects
  class AnalysisMatrixTacticFormPO
    def initialize(user, input_td)
      @user = user
      @inputs_tr = input_td.find(:xpath, "..")
      @submits_tr = input_td.find(:xpath, "../following-sibling::tr[1]")
    end

    def fill_who(text)
      fill_expression(:who, text)
    end

    def fill_what(text)
      fill_expression(:what, text)
    end

    def fill_where(text)
      fill_expression(:where, text)
    end

    def fill_when(text)
      fill_expression(:when, text)
    end

    def fill_response_action(text)
      fill_expression(:response_action, text)
    end

    def press_create
      value = get_who_value
      @submits_tr.click_on "Create"
      wait_until{@user.session.has_text? value}
      AnalysisMatrixPO.new(@user)
    end

    def press_update
      value = get_who_value
      @submits_tr.click_on "Update"
      wait_until{@user.session.has_text? value}
      AnalysisMatrixPO.new(@user)
    end

    def press_delete
      @submits_tr.click_on "Delete"
      wait_until{@user.session.has_no_css? ".tactic.form"}
      AnalysisMatrixPO.new(@user)
    end

    def get_who_value
      get_value_of(:who)
    end

    def get_what_value
      get_value_of(:what)
    end

    def get_where_value
      get_value_of(:where)
    end

    def get_when_value
      get_value_of(:when)
    end

    def get_response_action_value
      get_value_of(:response_action)
    end

    def press_cancel
      @submits_tr.click_on "Cancel"
    end
  private
    def fill_expression(expression_name, text)
      @inputs_tr.fill_in "tactic[#{expression_name}]", with: text
    end

    def get_value_of(expression_name)
      val = @inputs_tr.find(:xpath, ".//*[@name='tactic[#{expression_name}]']").value
      val && val.strip
    end
  end
end
