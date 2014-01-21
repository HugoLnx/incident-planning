json.array!(@cycles) do |cycle|
  json.extract! cycle, :id, :incident_id, :number, :current_object, :from, :to, :closed
  json.url cycle_url(cycle, format: :json)
end
