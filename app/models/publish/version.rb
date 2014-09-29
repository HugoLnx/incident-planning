module Publish
  module Version
    extend self

    def issue(user, cycle, ics234_pdf: nil, ics202_pdf:nil)
      version = ::Version.new_next_to cycle
      version.ics234_pdf = ics234_pdf
      version.ics202_pdf = ics202_pdf
      version.user = user
      version.save
      version
    end
  end
end
