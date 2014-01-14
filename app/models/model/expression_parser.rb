module Model
  class ExpressionParser
    def parse(hash)
      name = hash["name"]

      Expression.new(name)
    end

    def parse_all(hashes)
      hashes.map{|hash| parse hash}
    end
  end
end
