module AnalysisMatrixReuse
  module Strategy
    extend self
    def reuse_tactics!(strategy, owner: nil, reused: nil)
      group = strategy

      reused_group = reused

      ActiveRecord::Base.transaction do
        reused_group.childs.each do |child_to_reuse|
          reused = group_dup(child_to_reuse, group, owner)

          group.childs << reused
          reused.save!
          group.save!
        end
      end
    end
  private
    def group_dup(group_to_reuse, strategy, owner)
      reused = group_to_reuse.dup
      reused.cycle = strategy.cycle

      group_to_reuse.text_expressions.each do |exp_to_reuse|
        reused_exp = expression_dup(exp_to_reuse, strategy, owner)
        reused.text_expressions << reused_exp
        reused_exp.save!
      end

      group_to_reuse.time_expressions.each do |exp_to_reuse|
        reused_exp = expression_dup(exp_to_reuse, strategy, owner)
        reused.time_expressions << reused_exp
        reused_exp.save!
      end
      reused
    end

    def expression_dup(exp_to_reuse, strategy, owner)
      reused_exp = exp_to_reuse.dup
      reused_exp.owner = owner
      reused_exp.cycle = strategy.cycle
      reused_exp.reused = true
      reused_exp.artificial = true
      reused_exp
    end
  end
end
