module HistoryTracking
  class HistoryPersistence
    def initialize(session)
      @session = session
    end

    def add_url(name, value)
      UrlTrack.create!(session_id: session_id, track_type: name, url: value, datetime: DateTime.now)
      # destroy all olds
    end

    def pop_url(name)
      tracks = UrlTrack.where(session_id: session_id, track_type: name).last(2)
      if tracks.size == 2
        current_track = tracks.last
        last_track = tracks.first

        last_track.url
      else
        nil
      end
    end

    def destroy_last(name)
      track = UrlTrack.where(session_id: session_id, track_type: name).last(1)[0]
      track.destroy! if track
    end

    def last_action(name, action: nil, params: {})
      if action
        hash(name)[:last_action] = [action, params]
      else
        hash(name)[:last_action]
      end
    end
  private
    def hash(name)
      @session[:"__tracking_history_#{name}"] ||= {}
    end

    def session_id
      @session[:session_id]
    end
  end
end
