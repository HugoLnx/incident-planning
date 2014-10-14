class Company < ActiveRecord::Base
  has_many :incidents
  has_many :users

  validate :name, unique: true
end
