class ExpressionSuggestionsController < ApplicationController
  def index
    suggest_params = params.permit(:term, :expression_name)
    expressions = TextExpression.suggested(suggest_params).load
    suggestions = expressions.map(&:info_as_str)

    render json: suggestions
  end
end
