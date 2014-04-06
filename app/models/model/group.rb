module Model
  class Group
    attr_accessor :name, :creator_roles, :child, :expressions, :father

    def initialize(name, creator_roles = nil, child = nil, father = nil, expressions = [])
      @name = name
      @child = child
      @father = father
      @creator_roles = creator_roles || []
      @expressions = expressions || []
    end

    def ancestors
      ancestors = []
      group = self.father
      while group
        ancestors.push group
        group = group.father
      end
      ancestors
    end

    def path
      groups = ancestors.reverse
      groups << self

      groups.map(&:name).join("/")
    end

    def to_hash
      {
        name: @name,
        pretty_name: @name.downcase,
        expressions: @expressions.map(&:to_hash)
      }
    end
  end
end
