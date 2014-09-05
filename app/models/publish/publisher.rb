module Publish
  class Publisher
    def self.publish(cycle, ics234_pdf: nil, ics202_pdf: nil)
      incident_name = cycle.incident.name
      cycle.text_expressions.update_all(source: incident_name)
      cycle.time_expressions.update_all(source: incident_name)
      cycle.last_version.update(ics234_pdf: ics234_pdf, ics202_pdf: ics202_pdf)
      cycle.update(closed: true)
    end
  end
end
