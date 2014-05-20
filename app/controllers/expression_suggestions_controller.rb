class ExpressionSuggestionsController < ApplicationController
  def index
    suggest_params = params.permit(:term, :expression_name, :incident_id)
    expression_model = ::Model.find_expression_by_name(suggest_params[:expression_name])

    reuse_config = current_user.reuse_configuration
    if expression_model.type == ::Model::Expression::TYPES.time()
      expressions = TimeExpression.suggested_to_reuse(suggest_params, reuse_config).load
    else
      expressions = TextExpression.suggested_to_reuse(suggest_params, reuse_config).load
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
