module HistoryTracking
  class Tracker
    def initialize
      @histories = {}
    end

    def setup(name, &conditions)
      @histories[name] = History.new(&conditions)
    end

    def history(name)
      @histories[name]
    end

    def on_track(url, action, params, conditions_container, dao)
      dao.update_last_to_be_backable
      url_tracks = {}
      @histories.each do |type, history|
        url_tracks[type] = history.has_to_be_tracked?(action, params, conditions_container, dao)
      end
      dao.add_url(url, url_tracks, action: action, params: params)
    end

    def on_back(type, action, params, dao)
      url = dao.last_backable_url(type)
      dao.destroy_all_until_last_backable(type)
      dao.reset_session
      url
    end

    def undo_redirect(dao)
      dao.destroy_last_track
    end

    def get_back_url(type, dao)
      dao.last_backable_url(type)
    end
  end
end
