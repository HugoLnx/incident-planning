module Publish
  class Publisher
    def self.publish(cycle)
      incident_name = cycle.incident.name
      cycle.text_expressions.update_all(source: incident_name)
      cycle.time_expressions.update_all(source: incident_name)
      cycle.update(closed: true)
    end
  end
end
