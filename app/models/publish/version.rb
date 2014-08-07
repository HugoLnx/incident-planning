module Publish
  module Version
    extend self

    def issue(cycle)
      version = ::Version.new_next_to cycle
      version.save
    end
  end
end
