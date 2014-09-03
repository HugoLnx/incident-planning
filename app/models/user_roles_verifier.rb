class UserRolesVerifier
  INCIDENT_COMMANDER_IDS = [0, 7]
  PLANNING_CHIEF_IDS = [1, 8]
  OPERATIONS_CHIEF_ID = [2, 9]
  LOGISTICS_CHIEF_ID = [3, 10]

  def initialize(roles_ids)
    @roles_ids = roles_ids
  end

  def incident_commander?
    !(@roles_ids & INCIDENT_COMMANDER_IDS).empty?
  end

  def planning_chief?
    !(@roles_ids & PLANNING_CHIEF_IDS).empty?
  end

  def operations_chief?
    !(@roles_ids & OPERATIONS_CHIEF_ID).empty?
  end

  def logistics_chief?
    !(@roles_ids & LOGISTICS_CHIEF_ID).empty?
  end
end
