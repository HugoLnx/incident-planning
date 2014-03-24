module Model
  def self.root
    Model::Dao.new.root_group
  end

  def self.objective
    self.root.expressions.first
  end

  def self.strategy
    self.root.child
  end

  def self.tactic
    self.root.child.child
  end

  def self.strategy_how
    strategy.expressions.find{|expression| expression.name == "How"}
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

  def self.find_expression_by_name(name)
    expressions = root.expressions + strategy.expressions + tactic.expressions
    expressions.find{|expression| expression.name == name}
  end

  def self.to_json
    groups = {
      objective: self.root.to_hash,
      strategy: self.strategy.to_hash,
      tactic: self.tactic.to_hash
    }
    ActiveSupport::JSON.encode groups
  end
end
