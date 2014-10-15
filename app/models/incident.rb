class Incident < ActiveRecord::Base
  has_many :cycles, dependent: :destroy
  belongs_to :company

  validates :name, presence: true

  def closed?
    cycles.size > 0 && cycles.all?{|cycle| cycle.closed?}
  end

  def visibility_name
    if company.nil?
      "Public"
    else
      company.name
    end
  end
end
