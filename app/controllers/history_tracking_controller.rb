module HistoryTrackingController
  extend ActiveSupport::Concern

  included do
    before_filter :update_tracking_referers
    after_filter :check_redirect

    def self.track_history(prefix, &block)
      @@tracker ||= HistoryTracking::Tracker.new
      @@tracker.setup(prefix, &block)
    end

    def get_history(type)
      url = @@tracker.get_back_url(type, persistence_dao)
      if url
        if url.include?("?")
          url += "&_back_=#{type}"
        else
          url += "?_back_=#{type}"
        end
      end
      url
    end

  private
    def update_tracking_referers
      if params[:_back_] && !params[:_back_].empty?
        session[:_history_tracker_back_] = params[:_back_]
        redirect_to request.original_url.gsub(/[?&]_back_=[^\&]*/, "")
      elsif session[:_history_tracker_back_]
        type = session.delete :_history_tracker_back_
        url = @@tracker.on_back(type, resource_codename, params, persistence_dao)
        redirect_to url 
      elsif params[:format] != "json" &&
            params[:format] != "pdf" &&
            ::HistoryTracking::History.resource_changed?(persistence_dao, resource_codename, params)
        @@tracker.on_track(request.original_url,
          resource_codename, params, self, persistence_dao)
      end
    end

    def check_redirect
      if is_redirecting && params[:format] != "json" && params[:format] != "pdf"
        @@tracker.undo_redirect(persistence_dao)
      end
    end

    def resource_codename
      "#{controller_name}##{action_name}"
    end

    def is_redirecting
      !response.location.nil?
    end

    def persistence_dao
      HistoryTracking::HistoryPersistence.new(session)
    end
  end
end
