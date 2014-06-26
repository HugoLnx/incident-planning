class Incident < ActiveRecord::Base
  has_many :cycles, dependent: :destroy

  validates :name, presence: true

  def closed?
    cycles.all?{|cycle| cycle.closed?}
  end
end
