class ExpressionReuseAdviser
  def initialize(query)
    @query = query
  end

  def suggestions_query_for(config, expression_name, term, current_incident_id, excluded_expression_id)
    query = @query.where({
      name: expression_name
    })

    if config.user_filter_type == ReuseConfiguration::USER_FILTER_TYPES.name(:specific)
      query = apply_user_filter(query, config)
    end

    if config.incident_filter_type != ReuseConfiguration::INCIDENT_FILTER_TYPES.name(:all)
      query = apply_incident_filter(query, config, current_incident_id)
    end

    if config.date_filter
      query = apply_date_filter(query, config, query_table(expression_name))
    end

    query = QueryUtils.where_attr_like(query, :text, term)
    query = exclude_expression(query, excluded_expression_id)

    query
  end

  def self.filter_expressions(exps, config, expression_name)
    is_strategy = expression_name == ::Model.strategy_how.name
    is_reusing_hierarchy = config.reuse_hierarchy?
    if is_strategy && is_reusing_hierarchy
      exps
    else
      singlify_choices(exps) 
    end
  end

  def self.singlify_choices(expressions)
    texts = {}
    new_expressions = []
    expressions.each do |exp|
      text = exp.info_as_str
      if !texts[text]
        new_expressions << exp
        texts[text] = {
          exp: exp,
          index: new_expressions.size-1
        }
      elsif texts[text][:exp].created_at > exp.created_at
        new_expressions[texts[text][:index]] = exp
        texts[exp.info_as_str][:exp] = exp
      end
    end
    new_expressions
  end

private
  def apply_user_filter(query, config)
    user_id = config.user_filter_value
    query.where({owner_id: user_id})
  end

  def apply_incident_filter(query, config, current_incident_id)
    if config.incident_filter_type == ReuseConfiguration::INCIDENT_FILTER_TYPES.name(:specific)
      incident_id = config.incident_filter_value
    else
      incident_id = current_incident_id
    end
    query.joins(:cycle).where({"cycles.incident_id" => incident_id.to_i})
  end

  def apply_date_filter(query, config, query_table)
    months_from_now = config.date_filter
    date_limit = DateTime.now.beginning_of_day << months_from_now
    query.where("#{query_table}.created_at >= ?", date_limit)
  end

  def exclude_expression(query, exp_id)
    if exp_id.nil?
      query
    else
      query.where.not(id: exp_id)
    end
  end

  def query_table(expression_name)
    if expression_name == "When"
      "time_expressions"
    else
      "text_expressions"
    end
  end
end
