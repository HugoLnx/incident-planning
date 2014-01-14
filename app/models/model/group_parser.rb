module Model
  class GroupParser
    GROUP_KEY = "group"
    NAME_KEY = "name"
    EXPRESSIONS_KEY = "expressions"

    def initialize(expression_parser)
      @expression_parser = expression_parser
    end

    def parse(hash)
      return nil unless hash.has_key? GROUP_KEY

      group_hash = hash[GROUP_KEY]

      name = group_hash[NAME_KEY]
      child = parse group_hash
      expressions = parse_expressions group_hash

      Model::Group.new(name, child, expressions)
    end

  private

    def parse_expressions(group_hash)
      return nil unless group_hash.has_key?(EXPRESSIONS_KEY)
      @expression_parser.parse_all(group_hash[EXPRESSIONS_KEY])
    end
  end
end
