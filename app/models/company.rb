class Company < ActiveRecord::Base
  ADMIN_ID = 99999
  has_many :incidents
  has_many :users

  validate :name, unique: true

  def self.filter_by_associated_company(query, user_company_id)
    if user_company_id == Company::ADMIN_ID
      query
    else
      query.where("company_id = ? OR company_id is null", user_company_id)
    end
  end
end
