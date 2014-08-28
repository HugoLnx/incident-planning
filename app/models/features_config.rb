class FeaturesConfig < ActiveRecord::Base
  belongs_to :user

  def authority_control?
    thesis_tools?
  end

  def traceability?
    thesis_tools?
  end
end
