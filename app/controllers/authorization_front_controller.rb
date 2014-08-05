module AuthorizationFrontController
  extend ActiveSupport::Concern

  included do
    before_filter :verify_authorizations

    RESTRICTED_TO = {
      user: {
        "strategies" => true,
        "tactics" => true,
        "analysis_matrices" => true,
        "incidents" => true,
        "cycles" => true,
        "publishes" => true
      }
    }

  private
    def verify_authorizations
      RESTRICTED_TO.each do |user_modelname, controllers|
        controllers.each do |restricted_controller, _|
          if self.controller_name == restricted_controller
            send(:"authenticate_#{user_modelname}!")
          end
        end
      end
    end
  end
end
