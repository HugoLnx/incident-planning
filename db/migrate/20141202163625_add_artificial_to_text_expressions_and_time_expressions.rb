class AddArtificialToTextExpressionsAndTimeExpressions < ActiveRecord::Migration
  def change
    add_column :text_expressions, :artificial, :boolean, default: false
    add_column :time_expressions, :artificial, :boolean, default: false
  end
end
