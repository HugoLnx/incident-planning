module HistoryTracking
  class HistoryPersistence
    def initialize(session)
      @session = session
    end

    def add_url(name, value)
      hash(name)[:current_url] = value
    end

    def pop_url(name)
      hash(name)[:current_url]
    end

    def last_action(name, value: nil)
      if value
        hash(name)[:last_action] = value
      else
        hash(name)[:last_action]
      end
    end
  private
    def hash(name)
      @session[:"__tracking_history_#{name}"] ||= {}
    end
  end
end
