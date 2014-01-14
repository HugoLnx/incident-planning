module Roles
  class Parser
    def parse(str)
      str.strip.lines.map do |line|
        name = line.strip
        Role.new name
      end
    end
  end
end
