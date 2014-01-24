class AnalysisMatricesController < ApplicationController
  before_filter :set_incident_and_cycle
  before_filter :set_form234, only: [:new]

  def new
  end

private
  def set_form234
    @form234 = Forms::Form234.new
  end

  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end
