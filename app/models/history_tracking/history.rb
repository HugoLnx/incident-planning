module HistoryTracking
  class History
    def initialize(&conditions)
      @conditions = conditions
    end

    def try_track(name, url, action, is_redirecting, conditions_container, dao)
      if conditions_container.instance_eval(&@conditions) && !is_redirecting
        resource_changed = dao.last_action(name) != action
        if resource_changed
          dao.add_url(name, url)
        end
        dao.last_action(name, value: action)
      end
    end

    def pop(name, dao)
      dao.pop_url(name)
    end
  end
end
