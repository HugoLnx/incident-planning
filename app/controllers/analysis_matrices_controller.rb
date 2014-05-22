class AnalysisMatricesController < ApplicationController
  before_filter :set_incident_and_cycle

  def show
    dao = Dao::AnalysisMatrixDao.new(@cycle)
    objectives = dao.find_all_objectives_including_hierarchy
    @matrix_data = AnalysisMatrixData.new(objectives)

    @objective = ::Model.objective
    @strategy = ::Model.strategy
    @tactic = ::Model.tactic
  end

  def group_approval
    dao = Dao::AnalysisMatrixDao.new(@cycle)
    objectives = dao.find_all_objectives_including_hierarchy
    @matrix_data = AnalysisMatrixData.new(objectives)

    @objective = ::Model.objective
    @strategy = ::Model.strategy
    @tactic = ::Model.tactic

    render "show_with_group_approval"
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end

module Arel
  module Visitors
    class ToSql < Arel::Visitors::Visitor
      def quote_column_name name
        p name
        @quoted_columns[name] ||= Arel::Nodes::SqlLiteral === name ? name : @connection.quote_column_name(name)
      end
    end
  end
end
