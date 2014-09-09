class PublishesController < ApplicationController
  before_filter :set_incident_and_cycle

  def publish
    prepare_to_render_analysis_matrix(@cycle)

    all_messages = Publish::PublishValidation.errors_messages_on(
      @objectives, disable_approvals: !current_user.features_config.thesis_tools?)
    prepare_errors(all_messages)

    if !Publish::ValidationUtils.have_errors?(all_messages)
      Publish::Publisher.publish(@cycle, ics234_pdf: render_matrix_pdf, ics202_pdf: render_objectives_pdf)
      redirect_to action: :show
    else
      render "analysis_matrices/show"
    end
  end

  def new
    prepare_to_render_analysis_matrix(@cycle)

    all_messages = Publish::PublishValidation.errors_messages_on(
      @objectives, disable_approvals: !current_user.features_config.thesis_tools?)
    prepare_errors(all_messages)

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
    render_to_string pdf: "anything",
      template: "analysis_matrices/show.pdf.erb",
      layout: "application"
  end

  def render_objectives_pdf
    @final = true
    render_to_string pdf: "anything",
      template: "cycles/show.pdf.erb",
      layout: "application"
  end
end
