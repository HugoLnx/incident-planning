class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_roles, dependent: :destroy
  has_one :reuse_configuration
  validates_associated :user_roles
  after_initialize :defaults

  INCIDENT_COMMANDER_ID = 0
  PLANNING_CHIEF_ID = 1
  OPERATIONS_CHIEF_ID = 2

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

  def roles_names
    roles_ids.map{|id| Roles::Dao.new.find_by_id(id).name}
  end

  def main_role
    Roles::Dao.new.find_by_id roles_ids.first
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
  
  def can_publish?
    is_incident_commander = !user_role(INCIDENT_COMMANDER_ID).nil?
    is_planning_chief = !user_role(PLANNING_CHIEF_ID).nil?
    is_incident_commander || is_planning_chief
  end

  def can_issue_version?
    is_operations_chief = !user_role(OPERATIONS_CHIEF_ID).nil?
    is_planning_chief = !user_role(PLANNING_CHIEF_ID).nil?
    is_operations_chief || is_planning_chief
  end

private
  def defaults
    if !self.persisted?
      self.reuse_configuration ||= ReuseConfiguration.new(user: self)
    end
  end

end
