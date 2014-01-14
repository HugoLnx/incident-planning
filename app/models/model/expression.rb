module Model
  class Expression
    attr_reader :name
    attr_reader :type
    attr_reader :optional
    attr_reader :approval_roles
    attr_reader :father

    def initialize(name, type, optional, approval_roles, father)
      @name = name
      @type = type
      @optional = optional || false
      @approval_roles = approval_roles
      @father = father
    end
  end
end