require 'spec_helper'

describe AnalysisMatrixReuse::Strategy do
  it "reuse tactics" do
    user = create :user

    strategy_to_reuse = create :strategy_group
    tactic = create(:tactic_group)
    strategy_to_reuse.childs = [tactic]
    strategy_to_reuse.save!

    cycle = create :cycle

    exp = create :strategy_how,
      reused_expression: strategy_to_reuse.text_expressions.first,
      cycle: cycle

    group = exp.group
    group.text_expressions = [exp]
    group.save!

    AnalysisMatrixReuse::Strategy.reuse_hierarchy!(group, user)

    exp.reload
    group = exp.group
    expect(group.childs.count).to be == 1
    new_tactic_group = group.childs.first
    expect(new_tactic_group.cycle).to be == cycle
    expect(new_tactic_group.expressions.size).to be == tactic.expressions.size
    new_tactic_group.expressions.each do |new_exp|
      expect(new_exp.owner).to be == user
      expect(new_exp.cycle).to be == cycle
      expect(new_exp.reused_expression).to be == tactic.expressions.find{|exp| exp.name == new_exp.name}
    end
  end
end
