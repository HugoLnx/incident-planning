class PrioritiesProxy
  def initialize(cycle)
    @cycle = cycle
  end

  def owner
    first_obj = @cycle.text_expressions.objectives.first
    first_obj && first_obj.owner
  end

  def owner_human_id
    owner && owner.email
  end

  def approved?
    @cycle.priorities_approval_status
  end

  def source
    if @cycle.published?
      @cycle.incident.name
    else
      nil
    end
  end

  def text
    @cycle.priorities
  end
end
