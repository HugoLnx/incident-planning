class ExpressionSuggestionsController < ApplicationController
  def index
    suggest_params = params.permit(:term, :expression_name)
    expressions = TextExpression.suggested(suggest_params).load
    suggestions = expressions.map do |exp|
      {
        label: exp.info_as_str,
        value: exp.id
      }
    end

    render json: suggestions
  end
end
