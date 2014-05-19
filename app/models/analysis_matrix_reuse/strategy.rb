module AnalysisMatrixReuse
  module Strategy
    extend self
    def reuse_tactics!(strategy, owner)
      group = strategy
      exp = group.text_expressions.first

      reused_exp = TextExpression.where(id: exp.reused_expression_id).first
      reused_group = reused_exp.group

      ActiveRecord::Base.transaction do
        reused_group.childs.each do |child_to_reuse|
          reused = group_dup(child_to_reuse, exp, owner)

          group.childs << reused
          reused.save!
          group.save!
        end
      end
    end
  private
    def group_dup(group_to_reuse, strategy_exp, owner)
      reused = group_to_reuse.dup
      reused.cycle = strategy_exp.cycle

      group_to_reuse.text_expressions.each do |exp_to_reuse|
        reused_exp = expression_dup(exp_to_reuse, strategy_exp, owner)
        reused.text_expressions << reused_exp
        reused_exp.save!
      end

      group_to_reuse.time_expressions.each do |exp_to_reuse|
        reused_exp = expression_dup(exp_to_reuse, strategy_exp, owner)
        reused.time_expressions << reused_exp
        reused_exp.save!
      end
      reused
    end

    def expression_dup(exp_to_reuse, strategy_exp, owner)
      reused_exp = exp_to_reuse.dup
      reused_exp.owner = owner
      reused_exp.cycle = strategy_exp.cycle
      reused_exp.reused_expression = exp_to_reuse.group.expressions.find{|exp| exp.name == reused_exp.name}
      reused_exp
    end
  end
end
