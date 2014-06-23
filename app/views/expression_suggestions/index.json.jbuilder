json.array! @expressions do |expression|
  json.label expression.info_as_str
  json.value expression.id
end
