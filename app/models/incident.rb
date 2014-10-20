class Incident < ActiveRecord::Base
  has_many :cycles, dependent: :destroy
  belongs_to :company

  validates :name, presence: true

  scope :where_company, -> (user_company_id) do
    Company.filter_by_associated_company(scoped, user_company_id)
  end

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
