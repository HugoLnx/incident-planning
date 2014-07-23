module Publish
  class PublishValidation
    def self.errors_on(objectives_groups)
      expression_errors = Hash.new({})
      group_errors = Hash.new({})

      strategy_groups = []
      objectives_groups.each do |obj_group|
        errors = Validation::Objective.errors_on(obj_group)
        exp = obj_group.text_expressions.first
        expression_errors[exp.id] = errors unless errors.empty?
        strategy_groups += obj_group.childs
      end

      tactic_groups = []
      strategy_groups.each do |strategy_group|
        errors = Validation::Strategy.errors_on(strategy_group)
        how = strategy_group.text_expressions.first
        expression_errors[how.id] = errors unless errors.empty?
        tactic_groups += strategy_group.childs
      end

      tactic_groups.each do |tactic_group|
      #  errors = Publish::TacticValidator.errors_on(tactic_group)
      #  group_errors.merge!(errors)

        exps = tactic_group.expressions
      #  who = exps.find{|exp| exp.name == ::Model.tactic_who}
      #  errors = Publish::WhoValidator.errors_on(who)
      #  expression_errors[who.id] = errors unless errors.empty?

      #  what = exps.find{|exp| exp.name == ::Model.tactic_what}
      #  errors = Publish::WhatValidator.errors_on(what)
      #  expression_errors[what.id] = errors unless errors.empty?

        where = exps.find{|exp| exp.name == ::Model.tactic_where.name}
        errors = Validation::Where.errors_on(where)
        expression_errors[where.id] = errors unless errors.empty?

      #  when = exps.find{|exp| exp.name == ::Model.tactic_when}
      #  errors = Publish::WhenValidator.errors_on(when)
      #  expression_errors[when.id] = errors unless errors.empty?

      #  response = exps.find{|exp| exp.name == ::Model.tactic_response_action}
      #  errors = Publish::ResponseActionValidator.errors_on(response)
      #  expression_errors[response.id] = errors unless errors.empty?
      end

      return {
        expression: expression_errors,
        group: group_errors
      }
    end

    def self.get_messages(errors)
      messages = Hash.new([])
      errors.each do |key, exp_errors|
        messages[key] = exp_errors.messages.values.flatten
      end
      messages
    end
  end
end
