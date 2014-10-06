module PageObjects
  class DeviseSteps
    def initialize(session, routing)
      @session = session
      @routing = routing
    end

    def sign_in(user)
      @session.visit @routing.new_user_session_path
      @session.fill_in "user_email", with: user.email
      @session.fill_in "user_password", with: user.password
      @session.click_button I18n.t("auth.login")
    end
  end
end
