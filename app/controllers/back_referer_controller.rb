module BackRefererController
  extend ActiveSupport::Concern

  included do
    before_filter :update_get_referer
    before_filter :update_referer

    DONT_TRACK = {
      "expression_suggestions" => true
    }

    def back_path
      session[:GET_referer]
    end
    helper_method :back_path

    def general_back_path
      session[:referer]
    end
    helper_method :back_path

  protected
    def update_referer
      if !DONT_TRACK.keys.include?(self.controller_name)
        resource_changed = session[:last_resource] != resource_codename
        if resource_changed
          session[:referer] = session[:original_url]
          session[:original_url] = request.original_url
        end
        session[:last_resource] = resource_codename
      end
    end

    def update_get_referer
      if request.get? && !DONT_TRACK.keys.include?(self.controller_name)
        resource_changed = session[:last_getted_resource] != resource_codename
        if resource_changed
          session[:GET_referer] = session[:GET_original_url]
          session[:GET_original_url] = request.original_url
        end
        session[:last_getted_resource] = resource_codename
      end
    end

    def resource_codename
      "#{controller_name}##{action_name}"
    end
  end
end
