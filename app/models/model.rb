module Model
  def self.objective
    Dao.new.root_group.expressions.first
  end

  def self.strategy
    Dao.new.root_group.child
  end

  def self.tatic
    Dao.new.root_group.child.child
  end

  def self.strategy_how
    strategy.expressions.find{|expression| expression.name == "How"}
  end

  def self.strategy_why
    strategy.expressions.find{|expression| expression.name == "Why"}
  end

  def self.tatic_who
    tatic.expressions.find{|expression| expression.name == "Who"}
  end

  def self.tatic_what
    tatic.expressions.find{|expression| expression.name == "What"}
  end

  def self.tatic_where
    tatic.expressions.find{|expression| expression.name == "Where"}
  end

  def self.tatic_when
    tatic.expressions.find{|expression| expression.name == "When"}
  end

  def self.tatic_response_action
    tatic.expressions.find{|expression| expression.name == "Response Action"}
  end
end
