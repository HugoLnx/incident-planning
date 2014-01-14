module Roles
  class Dao
    ROLES_PATH = "config/roles.txt"

    def initialize
      @parser = Parser.new
    end

    def all
      @parser.parse File.read(ROLES_PATH)
    end
  end
end
