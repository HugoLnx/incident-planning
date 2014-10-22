module HistoryTracking
  class History
    def initialize(&conditions)
      @conditions = conditions
    end

    def has_to_be_tracked?(action, params, conditions_container, dao)
      if conditions_container.instance_eval(&@conditions)
        return History.resource_changed?(dao, action, params)
      end
      return false
    end

    def self.resource_changed?(dao, action, params)
      last_action = dao.last_action
      if last_action.nil?
        return true
      else
        return ((last_action[0] != action) || (last_action[1] != params))
      end
    end
  end
end
