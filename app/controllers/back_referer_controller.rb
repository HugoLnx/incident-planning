module BackRefererController
  extend ActiveSupport::Concern

  included do
    before_filter :update_get_referer

    def back_path
      session[:GET_referer]
    end
    helper_method :back_path

  protected
    def update_get_referer
      if request.get?
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
