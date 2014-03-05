module Model
  class Group
    attr_accessor :name, :child, :expressions, :father

    def initialize(name, child = nil, father = nil, expressions = [])
      @name = name
      @child = child
      @father = father
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
