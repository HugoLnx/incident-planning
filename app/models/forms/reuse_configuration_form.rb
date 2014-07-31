module Forms
  class ReuseConfigurationForm
      class Option
        attr_accessor :label, :value
      end
    include ActiveModel::Model

    attr_accessor :reuse_hierarchy, :user_filter, :incident_filter, :date_filter
    attr_reader :user

    USER_FILTER_ALL_OPTION = "-- All --"

    INCIDENT_FILTER_ALL_OPTION = "-- All --"
    INCIDENT_FILTER_CURRENT_OPTION ="-- Current Incident --"

    def initialize(user, params={})
      @user = user
      @configuration = user.reuse_configuration || ReuseConfiguration.new(user: @user)
      super(params)
    end

    def user_filter_options
      options = [{
        label: USER_FILTER_ALL_OPTION,
        value: USER_FILTER_ALL_OPTION
      } , {
        label: @user.human_id,
        value: @user.id
      }]

      User.all.each do |user|
        if user != @user
          options << ({
            label: user.human_id,
            value: user.id
          })
        end
      end
      options
    end

    def incident_filter_options
      options = [{
        label: INCIDENT_FILTER_ALL_OPTION,
        value: INCIDENT_FILTER_ALL_OPTION
      } , {
        label: INCIDENT_FILTER_CURRENT_OPTION,
        value: INCIDENT_FILTER_CURRENT_OPTION
      }]
      options += Incident.all.map do |incident|
        {
          label: incident.name,
          value: incident.id
        }
      end
      options
    end

    def reuse_hierarchy=(value)
      @configuration.hierarchy = value
    end

    def user_filter=(value)
      if value == USER_FILTER_ALL_OPTION
        @configuration.user_filter_type = ReuseConfiguration::USER_FILTER_TYPES.name(:all)
      else
        @configuration.user_filter_type = ReuseConfiguration::USER_FILTER_TYPES.name(:specific)
        @configuration.user_filter_value = value
      end
    end

    def incident_filter=(value)
      case value
      when INCIDENT_FILTER_ALL_OPTION
        @configuration.incident_filter_type = ReuseConfiguration::INCIDENT_FILTER_TYPES.name(:all)
      when INCIDENT_FILTER_CURRENT_OPTION
        @configuration.incident_filter_type = ReuseConfiguration::INCIDENT_FILTER_TYPES.name(:current)
      else
        @configuration.incident_filter_type = ReuseConfiguration::INCIDENT_FILTER_TYPES.name(:specific)
        @configuration.incident_filter_value = value
      end
    end

    def reuse_hierarchy
      @configuration.hierarchy
    end

    def user_filter
      if @configuration.user_filter_type == ReuseConfiguration::USER_FILTER_TYPES.name(:all)
        return USER_FILTER_ALL_OPTION 
      else
        return @configuration.user_filter_value
      end
    end

    def incident_filter
      case @configuration.incident_filter_type
      when ReuseConfiguration::INCIDENT_FILTER_TYPES.name(:all)
        return INCIDENT_FILTER_ALL_OPTION
      when ReuseConfiguration::INCIDENT_FILTER_TYPES.name(:current) 
        return INCIDENT_FILTER_CURRENT_OPTION 
      else
        return @configuration.incident_filter_value
      end
    end

    def date_filter=(date_filter)
      @configuration.date_filter = date_filter
    end

    def date_filter
      @configuration.date_filter
    end

    def persisted?
      @configuration.persisted?
    end

    def to_param
      @configuration.to_param
    end

    def save
      @configuration.save
    end

    def self.model_name
      ActiveModel::Name.new(::ReuseConfiguration)
    end
  end
end
