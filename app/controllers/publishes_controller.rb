class PublishesController < ApplicationController
  before_filter :set_incident_and_cycle

  def publish
    prepare_to_render_analysis_matrix(@cycle)
    prepare_errors(@publish_messages)

    if !@have_publish_errors
      Publish::Publisher.publish(@cycle, ics234_pdf: render_matrix_pdf, ics202_pdf: render_objectives_pdf)
      redirect_to action: :show
    else
      render "analysis_matrices/show"
    end
  end

  def new
    prepare_to_render_analysis_matrix(@cycle)
    prepare_errors(@publish_messages)

    render "analysis_matrices/show"
  end

  def show
    prepare_to_render_analysis_matrix(@cycle)
  end

private

  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
    @form202 = Forms::Form202.new_from(@cycle)
  end

  def render_matrix_pdf
    @final = true
    @version_number = @cycle.last_version.number
    render_to_string pdf: "anything",
      template: "analysis_matrices/show.pdf.erb",
      layout: "application"
  end

  def render_objectives_pdf
    @final = true
    @version_number = @cycle.last_version.number
    render_to_string pdf: "anything",
      template: "cycles/show.pdf.erb",
      layout: "application"
  end
end
