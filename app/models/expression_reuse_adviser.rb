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
      query = apply_date_filter(query, config)
    end

    query = where_text_like(query, term)
    query = exclude_expression(query, excluded_expression_id)

    query
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

  def apply_date_filter(query, config)
    months_from_now = config.date_filter
    date_limit = DateTime.now.beginning_of_day << config.date_filter
    query.where("created_at >= ?", date_limit)
  end

  def where_text_like(query, term)
    adapter = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
    if adapter == :postgresql
      query.where("text ilike ?", "%#{term}%")
    else
      query.where("text like ?", "%#{term}%")
    end
  end

  def exclude_expression(query, exp_id)
    if exp_id.nil?
      query
    else
      query.where.not(id: exp_id)
    end
  end
end
