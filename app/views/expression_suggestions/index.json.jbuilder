json.array! @suggestions do |expression_sug|
  json.text expression_sug.text
  json.label expression_sug.text
  json.value expression_sug.exp_id
  json.count expression_sug.count
  json.childs expression_sug.incidents do |incident_sug|
    json.text expression_sug.text
    json.label incident_sug.name
    json.value incident_sug.exp_id
    json.count incident_sug.count
    json.childs incident_sug.dates do |date_sug|
      json.text expression_sug.text
      json.label date_sug.date.strftime "%d/%m/%Y %H:%M"
      json.value date_sug.exp_id
      json.count 1
    end
  end
end
