class Company < ActiveRecord::Base
  ADMIN_ID = 99999
  has_many :incidents
  has_many :users

  validate :name, unique: true
end
