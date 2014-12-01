module HistoryTracking
  class HistoryPersistence
    def initialize(session)
      @session = session
    end

    def update_last_to_be_backable
      track = last_track
      track && track.update(is_backable: true)
    end

    def add_url(url, types, action: nil, params: {})
      attrs = types.merge({url: url, session_id: session_id, datetime: DateTime.now})
      UrlTrack.create!(attrs)
      UrlTrack.where("datetime < ?", (Time.now - 3.hours)).destroy_all
      last_action(action: action, params: params)
    end

    def last_backable_url(type)
      track = last_backable_track(type)
      track && track.url
    end

    def destroy_all_until_last_backable(type)
      datetime = last_backable_track(type).datetime
      base_query.where("datetime >= ?", datetime).destroy_all
    end

    def destroy_last_track
      track = last_track
      track && track.destroy
    end

    def reset_session
      hash.delete :last_action
    end

    def last_action(action: nil, params: {})
      if action
        hash[:last_action] = [action, params]
      else
        hash[:last_action]
      end
    end
  private
    def hash
      @session[:"__tracking_history__"] ||= {}
    end

    def session_id
      @session[:session_id]
    end

    def base_query
      UrlTrack.where(session_id: session_id)
    end

    def last_backable_track(type)
      base_query.where(is_backable: true, type => true).last(1)[0]
    end

    def last_track
      base_query.last(1)[0]
    end
  end
end
