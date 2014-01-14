module Model
  class GroupParser
    def parse(hash)
      group_hash = hash["group"]
      group = Model::Group.new(group_hash["name"])
      return group
    end
  end
end
