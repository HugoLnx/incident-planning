module Publish
  class PublishValidation
    def self.errors_on(objectives_groups)
      expression_errors = Hash.new([])
      group_errors = Hash.new([])

      strategy_groups = []
      objectives_groups.each do |obj_group|
        errors = Validation::Objective.errors_on(obj_group)
        exp = obj_group.text_expressions.first
        expression_errors[exp.id] += errors.entries unless errors.empty?
        strategy_groups += obj_group.childs
      end

      tactic_groups = []
      strategy_groups.each do |strategy_group|
        errors = Validation::Strategy.errors_on(strategy_group)
        how = strategy_group.text_expressions.first
        expression_errors[how.id] += errors.entries unless errors.empty?
        tactic_groups += strategy_group.childs
        
        errors = Validation::StrategyDuplication.errors_on(strategy_group, objectives_groups)
        expression_errors[how.id] += errors.entries unless errors.empty?
      end

      tactic_groups.each do |tactic_group|
        exps = tactic_group.expressions
        who = exps.find{|exp| exp.name == ::Model.tactic_who.name}
        what = exps.find{|exp| exp.name == ::Model.tactic_what.name}
        where = exps.find{|exp| exp.name == ::Model.tactic_where.name}
        when_exp = exps.find{|exp| exp.name == ::Model.tactic_when.name}
        response = exps.find{|exp| exp.name == ::Model.tactic_response_action.name}

        errors = Validation::Who.errors_on(who)
        expression_errors[who.id] = errors.entries unless errors.empty?

        errors = Validation::What.errors_on(what)
        expression_errors[what.id] = errors.entries unless errors.empty?

        errors = Validation::Where.errors_on(where)
        expression_errors[where.id] += errors.entries unless errors.empty?

        errors = Validation::When.errors_on(when_exp)
        expression_errors[when_exp.id] = errors.entries unless errors.empty?

        errors = Validation::ResponseAction.errors_on(response)
        expression_errors[response.id] = errors.entries unless errors.empty?
        
        errors = Validation::TacticDuplication.group_errors_on(tactic_group, strategy_groups)
        group_errors[[who.id, what.id, where.id]] += errors.entries unless errors.empty?
      end

      return {
        expression: expression_errors,
        group: group_errors
      }
    end

    def self.get_messages(errors)
      messages = Hash.new([])
      errors.each do |key, exp_errors|
        messages[key] = exp_errors.map(&:last).flatten.map(&:capitalize)
      end
      messages
    end
  end
end
