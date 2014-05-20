class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_roles, dependent: :destroy
  has_one :reuse_configuration
  validates_associated :user_roles

  INCIDENT_COMMANDER_ID = 0

  def roles_ids=(roles_ids)
    valids_size = 0
    roles_ids.each.with_index do |role_id, i|
      unless role_id.blank?
        valids_size += 1
        if self.user_roles[i]
          self.user_roles[i].update role_id: role_id
        else
          self.user_roles << UserRole.new(role_id: role_id)
        end
      end
    end

    self.user_roles = self.user_roles.first(valids_size)
  end

  def roles_ids
    user_roles.map(&:role_id)
  end

  def user_role(role_id)
    user_roles.find{|user_role| user_role.role_id == role_id}
  end

  def human_id
    email
  end
  
  def can_approve_all_objectives_at_once?
    is_incident_commander = !user_role(INCIDENT_COMMANDER_ID).nil?
  end
  
  def can_approve_priorities?
    is_incident_commander = !user_role(INCIDENT_COMMANDER_ID).nil?
  end
end
