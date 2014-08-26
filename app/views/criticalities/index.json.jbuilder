json.array!(@groups) do |group|
  json.group_id group.id
  json.criticality group.criticality
end
