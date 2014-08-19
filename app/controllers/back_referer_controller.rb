module BackRefererController
  extend ActiveSupport::Concern

  included do
    include HistoryTrackingController

    DONT_TRACK = {
      "expression_suggestions" => true
    }

    CONFIG_CONTROLLERS = {
      "reuse_configurations" => true,
      "features_configs" => true,
      "registrations" => true
    }

    track_history :general_referer do |history|
      !DONT_TRACK.keys.include?(self.controller_name)
    end

    track_history :get_referer do |history|
      request.get? &&
      !DONT_TRACK.keys.include?(self.controller_name)
    end

    track_history :from_config_referer do |history|
      request.get? &&
      !DONT_TRACK.keys.include?(self.controller_name) &&
      !CONFIG_CONTROLLERS.keys.include?(self.controller_name)
    end

    def back_path
      get_history :get_referer
    end
    helper_method :back_path

    def general_back_path
      get_history :general_referer
    end
    helper_method :general_back_path

    def from_config_back_path
      get_history :from_config_referer
    end
    helper_method :from_config_back_path
  end
end
