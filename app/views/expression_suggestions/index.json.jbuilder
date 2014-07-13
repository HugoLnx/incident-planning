json.array! @suggestions do |(_, expressions)|
  expression = expressions.first
  json.label expression.info_as_str
  json.value expression.id
  json.count expressions.size
end
