json.array!(@incidents) do |incident|
  json.extract! incident, :id, :name
  json.url incident_url(incident, format: :json)
end
