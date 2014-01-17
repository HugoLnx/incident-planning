module Model
  class ExpressionParser
    NAME_KEY = "name"
    TYPE_KEY = "type"
    OPTIONAL_KEY = "optional"
    APPROVAL_ROLES_KEY = "approval-roles"

    DEFAULT_TYPE = Expression::TYPES.text

    def parse(hash, father = nil)
      name = hash[NAME_KEY]
      if hash[TYPE_KEY].nil?
        type = DEFAULT_TYPE
      else
        type = Expression::TYPES[hash[TYPE_KEY]]
      end
      optional = hash[OPTIONAL_KEY]
      approval_roles = hash[APPROVAL_ROLES_KEY]

      Expression.new(name, type, optional, approval_roles, father)
    end

    def parse_all(hashes, father = nil)
      hashes.map{|hash| parse hash, father}
    end
  end
end
