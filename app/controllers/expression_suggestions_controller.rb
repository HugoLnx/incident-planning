class ExpressionSuggestionsController < ApplicationController
  before_filter :check_enabled

  def index
    sparams = params.permit(:term, :expression_name, :incident_id, :expression_updated_id)

    term = sparams[:term]
    current_incident_id = sparams[:incident_id]
    expression_name = sparams[:expression_name]
    to_be_updated_id = sparams[:expression_updated_id]
    expression_model = ::Model.find_expression_by_name(expression_name)

    if expression_model.type == ::Model::Expression::TYPES.time()
      query = TimeExpression.all
    else
      query = TextExpression.all
    end

    query = query.includes(cycle: :incident)

    adviser = ExpressionReuseAdviser.new(query)

    query = adviser.suggestions_query_for(
      current_user, expression_name, term,
      current_incident_id, to_be_updated_id)

    reuse_config = current_user.reuse_configuration

    @expressions = ExpressionReuseAdviser.filter_expressions(query.load, reuse_config, expression_name)
    @suggestions = SuggestionsTree::ExpressionSuggestion.from_expressions(@expressions)
  end

private
  def check_enabled
    reuse_config = current_user.reuse_configuration
    if !reuse_config.enabled?
      @expressions = []
      @suggestions = SuggestionsTree::ExpressionSuggestion.from_expressions(@expressions)
      render "index"
    end
  end
end
