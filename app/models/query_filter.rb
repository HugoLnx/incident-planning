class QueryFilter
  def initialize(query)
    @query = query
  end

  def filter(term, by: [])
    attrs = by
    if QueryUtils.postgresql?
      attrs.map!{|attr| "COALESCE(#{attr}, '')"}
      concat = "(#{attrs.join(" || ")})"
    else
      attrs.map!{|attr| "IFNULL(#{attr}, '')"}
      concat = "CONCAT(#{attrs.join(",")})"
    end
    QueryUtils.where_attr_like(@query, concat, term)
  end
end
