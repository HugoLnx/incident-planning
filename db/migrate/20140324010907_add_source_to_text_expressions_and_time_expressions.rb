class AddSourceToTextExpressionsAndTimeExpressions < ActiveRecord::Migration
  def change
    %i{text_expressions time_expressions}.each do |table|
      add_column table, :source, :integer, limit: 5, null: false, default: 0
    end

    (TextExpression.all + TimeExpression.all).each do |exp|
      if exp.source.nil?
        exp.update_attribute :source, 0
      end
    end
  end
end
