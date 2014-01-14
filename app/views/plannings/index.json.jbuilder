json.array!(@plannings) do |planning|
  json.extract! planning, :id, :incident_name, :priorities_list, :from, :to, :cycle
  json.url planning_url(planning, format: :json)
end
