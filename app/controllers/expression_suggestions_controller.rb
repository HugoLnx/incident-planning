class ExpressionSuggestionsController < ApplicationController
  def index
    sparams = params.permit(:term, :expression_name, :incident_id, :expression_updated_id)

    term = sparams[:term]
    current_incident_id = sparams[:incident_id]
    expression_name = sparams[:expression_name]
    to_be_updated_id = sparams[:expression_updated_id]
    expression_model = ::Model.find_expression_by_name(expression_name)

    if expression_model.type == ::Model::Expression::TYPES.time()
      adviser = ExpressionReuseAdviser.new(TimeExpression.all)
    else
      adviser = ExpressionReuseAdviser.new(TextExpression.all)
    end

    reuse_config = current_user.reuse_configuration

    query = adviser.suggestions_query_for(
      reuse_config, expression_name, term,
      current_incident_id, to_be_updated_id)

    @suggestions = query.load.group_by(&:info_as_str)
  end
end
