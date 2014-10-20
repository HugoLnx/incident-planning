class PrioritiesProxy
  def initialize(cycle)
    @cycle = cycle
  end

  def owner
    @cycle.text_expressions.objectives.first.owner
  end

  def owner_human_id
    owner.email
  end

  def approved?
    @cycle.priorities_approval_status
  end

  def source
    if @cycle.published?
      @cycle.owner.email
    else
      nil
    end
  end

  def text
    @cycle.priorities
  end
end
