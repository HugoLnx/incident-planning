class ExpressionSuggestionsController < ApplicationController
  def index
    suggest_params = params.permit(:term, :expression_name)
    expression_model = ::Model.find_expression_by_name(suggest_params[:expression_name])
    if expression_model.type == ::Model::Expression::TYPES.time()
      expressions = TimeExpression.suggested(suggest_params).load
    else
      expressions = TextExpression.suggested(suggest_params).load
    end
    suggestions = expressions.map do |exp|
      {
        label: exp.info_as_str,
        value: exp.id
      }
    end

    render json: suggestions
  end
end
