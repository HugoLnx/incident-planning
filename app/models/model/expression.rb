module Model
  class Expression
    attr_reader :name
    attr_reader :type
    attr_reader :optional
    attr_reader :approval_roles
    attr_reader :father

    TYPES = TypesLib::Enum.new(%w{text time external})

    def initialize(name, type, optional, approval_roles, father)
      @name = name
      @type = type
      @optional = optional || false
      @approval_roles = approval_roles
      @father = father
    end

    def path
      if self.father
        [self.father.path, self.name].join("/")
      else
        self.name
      end
    end
  end
end
