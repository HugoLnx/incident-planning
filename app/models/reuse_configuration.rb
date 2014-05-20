class ReuseConfiguration < ActiveRecord::Base
  belongs_to :user

  USER_FILTER_TYPES = TypesLib::Enum.new(%w{specific all})
  INCIDENT_FILTER_TYPES = TypesLib::Enum.new(%w{current specific all})

  validates :user_filter_type,
    inclusion: {in: USER_FILTER_TYPES.names}


  validates :incident_filter_type,
    inclusion: {in: INCIDENT_FILTER_TYPES.names}

  validates :user, associated: true

  def reuse_hierarchy?
    hierarchy
  end
end
