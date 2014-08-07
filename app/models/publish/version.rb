module Publish
  module Version
    extend self

    def issue(cycle, pdf)
      version = ::Version.new_next_to cycle
      version.pdf = pdf
      version.save
    end
  end
end
