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

    def update_tracks(url, action, params, conditions_container, dao, backing: false)
      @histories.each do |name, history|
        history.try_track(name, url, action, params, conditions_container, dao, backing)
      end
    end

    def undo_redirect(conditions_container, dao)
      @histories.each do |name, history|
        history.undo_redirect(name, conditions_container, dao)
      end
    end
  end
end
