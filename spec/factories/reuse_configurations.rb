FactoryGirl.define do
  factory :reuse_configuration do
    user
    user_filter_value nil
    incident_filter_value nil
    user_filter_type ReuseConfiguration::USER_FILTER_TYPES.name(:all)
    incident_filter_type ReuseConfiguration::INCIDENT_FILTER_TYPES.name(:all)
    date_filter nil
    hierarchy true
  end
end
