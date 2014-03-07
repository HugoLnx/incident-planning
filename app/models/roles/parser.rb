module Roles
  class Parser
    def parse(str)
      str.strip.lines.map do |line|
        role = line.strip
        match = role.match(/(\d+):(.*)/)
        id = match[1].strip.to_i
        name = match[2].strip
        Role.new name, id
      end
    end
  end
end
