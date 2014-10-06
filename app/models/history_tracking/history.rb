module HistoryTracking
  class History
    def initialize(&conditions)
      @conditions = conditions
    end

    def try_track(name, url, action, params, conditions_container, dao, backing)
      if backing
        dao.destroy_last(name)
        dao.last_action(name, action: action, params: params)
      else
        if conditions_container.instance_eval(&@conditions)
          last_action = dao.last_action(name)
          resource_changed = last_action && ((last_action[0] != action) || (last_action[1] != params))
          if resource_changed
            dao.add_url(name, url)
          end
          dao.last_action(name, action: action, params: params)
        end
      end
    end

    def undo_redirect(name, conditions_container, dao)
      if conditions_container.instance_eval(&@conditions)
        dao.destroy_last(name)
      end
    end

    def pop(name, dao)
      dao.pop_url(name)
    end
  end
end
