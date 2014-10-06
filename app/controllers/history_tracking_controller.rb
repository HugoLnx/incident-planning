module HistoryTrackingController
  extend ActiveSupport::Concern

  included do
    before_filter :update_tracking_referers
    after_filter :check_redirect

    def self.track_history(prefix, &block)
      @@tracker ||= HistoryTracking::Tracker.new
      @@tracker.setup(prefix, &block)
    end

    def get_history(name)
      url = @@tracker.history(name).pop(name, persistence_dao)
      if url
        if url.include?("?")
          url += "&_back_=true"
        else
          url += "?_back_=true"
        end
      end
      url
    end

  private
    def update_tracking_referers
      if params[:_back_] == "true"
        session[:_history_tracker_back_] = true
        redirect_to request.original_url.gsub(/[?&]_back_=true/, "")
      elsif params[:format] != "json" && params[:format] != "pdf"
        @@tracker.update_tracks(request.original_url,
          resource_codename, params, self, persistence_dao,
          backing: session[:_history_tracker_back_])
        session[:_history_tracker_back_] = false
      end
    end

    def check_redirect
      if is_redirecting && params[:format] != "json" && params[:format] != "pdf"
        @@tracker.undo_redirect(self, persistence_dao)
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
