class Incident < ActiveRecord::Base
  has_many :cycles

  validates :name, presence: true

  def closed?
    cycles.all?{|cycle| cycle.closed?}
  end
end
