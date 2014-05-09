class AddTextToTimeExpression < ActiveRecord::Migration
  def change
    add_column :time_expressions, :text, :string
  end
end
