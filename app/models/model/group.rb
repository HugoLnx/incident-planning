module Model
  class Group
    attr_reader :name, :child, :expressions

    def initialize(name, child, expressions=[])
      @name = name
      @child = child
      @expressions = expressions || []
    end
  end
end
