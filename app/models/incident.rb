class Incident < ActiveRecord::Base
  has_many :cycles, dependent: :destroy

  validates :name, presence: true

  def closed?
    cycles.size > 0 && cycles.all?{|cycle| cycle.closed?}
  end
end
