module HistoryTrackingController
  extend ActiveSupport::Concern

  included do
    before_filter :update_tracking_referers

    def self.track_history(prefix, &block)
      @@tracker ||= HistoryTracking::Tracker.new
      @@tracker.setup(prefix, &block)
    end

    def get_history(name)
      @@tracker.history(name).pop(name, persistence_dao)
    end

  private
    def update_tracking_referers
      if params[:format] != "json" && params[:format] != "pdf"
        @@tracker.update_tracks(request.original_url, resource_codename, params, is_redirecting, self, persistence_dao)
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
