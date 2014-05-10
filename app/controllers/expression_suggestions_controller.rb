class ExpressionSuggestionsController < ApplicationController
  def index
    suggest_params = params.permit(:term, :expression_name)
    expressions = TextExpression.where({name: suggest_params[:expression_name]})
                                .where("text like ?", "%#{suggest_params[:term]}%").load
    suggestions = expressions.map(&:info_as_str)

    render json: suggestions
  end
end
