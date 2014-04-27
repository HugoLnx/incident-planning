class UserRole < ActiveRecord::Base
  self.table_name = :user_roles

  belongs_to :user

  validate :role_available

private
  def role_available
    available_ids = Roles::Dao.new.all.map(&:id)
    if !available_ids.include?(role_id)
      errors.add(:role_id, "is not available")
    end
  end
end
