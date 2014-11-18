class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_roles, dependent: :destroy
  has_one :reuse_configuration
  has_one :features_config
  belongs_to :company
  validates_associated :user_roles
  after_initialize :defaults

  default_scope {order(name: :asc)}

  scope :where_company, -> (user_company_id) do
    Company.filter_by_associated_company(scoped, user_company_id)
  end

  validates :phone,
    format: {
      with: /\A\(\d{2}\)\d{4,5}\-\d{4}\Z/
    },
    presence: true

  validates :name,
    presence: true

  def company_name
    (company && company.name) || "none"
  end

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

  def features_config
    current_config = super
    if current_config.nil?
      current_config = FeaturesConfig.new(user: self)
      current_config.save!
    end
    current_config
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
    verifier = UserRolesVerifier.new(self.roles_ids)
    verifier.incident_commander?
  end
  
  def can_approve_priorities?
    verifier = UserRolesVerifier.new(self.roles_ids)
    verifier.incident_commander?
  end
  
  def can_publish?
    verifier = UserRolesVerifier.new(self.roles_ids)
    verifier.incident_commander? || verifier.planning_chief?
  end

  def can_issue_version?
    verifier = UserRolesVerifier.new(self.roles_ids)
    verifier.operations_chief? || verifier.planning_chief?
  end

  def can_approve_any_expression_of?(group)
    group_model = ::Model.find_by_group_name(group.name)
    permission = GroupPermission.new(group_model)
    can_approve = permission.to_approve?(self)

    is_all_already_approved = group.expressions.all? do |exp|
      approval_expert = ExpressionApprovalExpert.new(exp)
      approval_expert.already_had_needed_role_approval?(self.roles_ids)
    end

    can_approve && !is_all_already_approved
  end

  def in_admin_company?
    company_id == Company::ADMIN_ID
  end

private
  def defaults
    if !self.persisted?
      self.reuse_configuration ||= ReuseConfiguration.new(user: self)
    end
  end

end
