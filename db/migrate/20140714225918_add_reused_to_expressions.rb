class AddReusedToExpressions < ActiveRecord::Migration
  def up
    add_column :text_expressions, :reused, :boolean, null: false, default: false
    add_column :time_expressions, :reused, :boolean, null: false, default: false

    ActiveRecord::Base.transaction do
      TextExpression.includes(:reused_expression).where.not(reused_expression_id: nil).load.each do |exp|
        exp.text = exp.reused_expression.text
        exp.reused = true
        exp.save
      end

      TimeExpression.includes(:reused_expression).where.not(reused_expression_id: nil).load.each do |exp|
        exp.text = exp.reused_expression.text
        exp.when = exp.reused_expression.when
        exp.reused = true
        exp.save
      end
    end

    remove_column :text_expressions, :reused_expression_id
    remove_column :time_expressions, :reused_expression_id
  end

  def down
    remove_column :text_expressions, :reused, :boolean
    remove_column :time_expressions, :reused, :boolean
    add_column :text_expressions, :reused_expression_id, :integer
    add_column :time_expressions, :reused_expression_id, :integer
    add_index "text_expressions", ["reused_expression_id"], name: "index_text_expressions_on_reused_expression_id", using: :btree
    add_index "time_expressions", ["reused_expression_id"], name: "index_time_expressions_on_reused_expression_id", using: :btree
  end
end
