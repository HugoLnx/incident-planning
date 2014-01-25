module Model
  def self.objective
    Model::Dao.new.root_group.expressions.first
  end

  def self.strategy
    Model::Dao.new.root_group.child
  end

  def self.tactic
    Model::Dao.new.root_group.child.child
  end

  def self.strategy_how
    strategy.expressions.find{|expression| expression.name == "How"}
  end

  def self.strategy_why
    strategy.expressions.find{|expression| expression.name == "Why"}
  end

  def self.tactic_who
    tactic.expressions.find{|expression| expression.name == "Who"}
  end

  def self.tactic_what
    tactic.expressions.find{|expression| expression.name == "What"}
  end

  def self.tactic_where
    tactic.expressions.find{|expression| expression.name == "Where"}
  end

  def self.tactic_when
    tactic.expressions.find{|expression| expression.name == "When"}
  end

  def self.tactic_response_action
    tactic.expressions.find{|expression| expression.name == "Response Action"}
  end
end
