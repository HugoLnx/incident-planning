module Roles
  class Dao
    ROLES_PATH = "config/roles.txt"

    def initialize
      @parser = Parser.new
    end

    def all
      @parser.parse File.read(ROLES_PATH)
    end

    def find_by_id(role_id)
      all.find{|role| role.id == role_id}
    end
  end
end
