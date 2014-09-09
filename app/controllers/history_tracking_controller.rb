module HistoryTrackingController
  extend ActiveSupport::Concern

  included do
    after_filter :update_tracking_referers

    def self.track_history(prefix, &block)
      @@trackings ||= {}
      @@trackings.merge!({prefix => block})
    end

    def get_history(prefix)
      current_tracked_name = :"#{prefix}_current_tracked"
      history = session[:__tracker_history__] || {}
      history[current_tracked_name]
    end

  private
    def update_tracking_referers
      tracker = session[:__tracker_history__] ||= {}
      (@@trackings || {}).each_pair do |prefix, have_to_track|
        update_tracking_referer(prefix, have_to_track)
      end
    end

    def update_tracking_referer(prefix, have_to_track_request)
      current_tracked_name = :"#{prefix}_current_tracked"
      last_tracked_name = :"#{prefix}_last_tracked"
      last_resource_name = :"#{prefix}_last_resource"
      tracker = session[:__tracker_history__] ||= {}
      tracker[current_tracked_name] = tracker[last_tracked_name]

      if self.instance_eval(&have_to_track_request) && is_not_redirecting
        resource_changed = tracker[last_resource_name] != resource_codename
        if resource_changed
          tracker[last_tracked_name] = request.original_url
        end
        tracker[last_resource_name] = resource_codename
      end
    end

    def resource_codename
      "#{controller_name}##{action_name}"
    end

    def is_not_redirecting
      response.location.nil?
    end
  end
end
