class Incident < ActiveRecord::Base
  has_many :cycles
end
