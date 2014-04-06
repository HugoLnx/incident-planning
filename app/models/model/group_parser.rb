module Model
  class GroupParser
    GROUP_KEY = "group"
    NAME_KEY = "name"
    CREATOR_ROLES_KEY = "creator-roles"
    EXPRESSIONS_KEY = "expressions"

    def initialize(expression_parser)
      @expression_parser = expression_parser
    end

    def parse(hash, father = nil)
      return nil unless hash.has_key? GROUP_KEY

      group_hash = hash[GROUP_KEY]

      name = group_hash[NAME_KEY]
      group = Model::Group.new(name)
      group.creator_roles = group_hash[CREATOR_ROLES_KEY]
      group.father = father
      group.child = parse(group_hash, group)
      parse_expressions(group_hash, group)
      group
    end

  private

    def parse_expressions(group_hash, father)
      return nil unless group_hash.has_key?(EXPRESSIONS_KEY)
      exps = @expression_parser.parse_all(group_hash[EXPRESSIONS_KEY], father)
      father.expressions.concat exps
    end
  end
end
