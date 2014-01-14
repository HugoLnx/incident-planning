module Model
  class Expression
    attr_reader :name
    attr_reader :type
    attr_reader :optional
    attr_reader :approval_roles

    def initialize(name, type, optional, approval_roles)
      @name = name
      @type = type
      @optional = optional || false
      @approval_roles = approval_roles
    end
  end
end
