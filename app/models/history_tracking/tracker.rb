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

    def update_tracks(url, action, is_redirecting, conditions_container, dao)
      @histories.each do |name, history|
        history.try_track(name, url, action, is_redirecting, conditions_container, dao)
      end
    end
  end
end
