module Publish
  module Version
    extend self

    def issue(cycle, ics234_pdf: nil, ics202_pdf:nil)
      version = ::Version.new_next_to cycle
      version.ics234_pdf = ics234_pdf
      version.ics202_pdf = ics202_pdf
      version.save
    end
  end
end
