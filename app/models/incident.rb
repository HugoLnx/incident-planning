class Incident < ActiveRecord::Base
  has_many :cycles

  validates :name, presence: true
end
