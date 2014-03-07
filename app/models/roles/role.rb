module Roles
  class Role
    attr_reader :name, :id

    ROLES_PATH = "config/roles.txt"

    def all
      Parser.new.parse(File.read(ROLES_PATH))
    end

    def initialize(name, id)
      @name = name
      @id = id
    end
  end
end
