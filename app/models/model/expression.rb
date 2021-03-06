module Model
  class Expression
    attr_reader :name
    attr_reader :type
    attr_reader :optional
    attr_reader :approval_roles
    attr_reader :human_name
    attr_reader :father

    TYPES = TypesLib::Enum.new(%w{text time external})

    def initialize(name, type, optional, approval_roles, father, human_name=nil)
      @name = name
      @type = type
      @optional = optional || false
      @approval_roles = approval_roles
      @father = father
      @human_name = human_name
    end

    def path
      if self.father
        [self.father.path, self.name].join("/")
      else
        self.name
      end
    end

    def pretty_name
      @name.downcase.gsub(/ /, "_")
    end

    def human_name
      @human_name || @name
    end

    def to_hash
      {
        name: @name,
        pretty_name: pretty_name,
        optional: @optional,
        type: @type
      }
    end
  end
end
