class VersionsController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    prepare_to_render_analysis_matrix(@cycle)

    all_messages = Publish::VersionValidation.errors_messages_on(
      @objectives, disable_approvals: !current_user.features_config.thesis_tools?)
    prepare_errors(all_messages)

    if !Publish::ValidationUtils.have_errors?(all_messages)
      Publish::Version.issue(current_user, @cycle, ics234_pdf: render_matrix_pdf, ics202_pdf: render_objectives_pdf)
      redirect_to controller: :analysis_matrices, action: :show
    else
      render "analysis_matrices/show"
    end
  end

  def new
    prepare_to_render_analysis_matrix(@cycle)

    all_messages = Publish::VersionValidation.errors_messages_on(
      @objectives, disable_approvals: !current_user.features_config.thesis_tools?)
    prepare_errors(all_messages)

    render "analysis_matrices/show"
  end

  def index
    @versions = @cycle.versions
  end

  def show_ics234
    version = Version.find(params[:id])
    respond_to do |format|
      naming = PdfNaming.existent_version(version, extension: true)
      format.pdf {send_data version.ics234_pdf, filename: naming.ics234}
    end
  end

  def show_ics202
    version = Version.find(params[:id])
    respond_to do |format|
      naming = PdfNaming.existent_version(version, extension: true)
      format.pdf {send_data version.ics202_pdf, filename: naming.ics202}
    end
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
    @form202 = Forms::Form202.new_from(@cycle)
  end

  def render_matrix_pdf
    @for_review = true
    render_to_string pdf: "anything",
      template: "analysis_matrices/show.pdf.erb",
      layout: "application"
  end

  def render_objectives_pdf
    @for_review = true
    render_to_string pdf: "anything",
      template: "cycles/show.pdf.erb",
      layout: "application"
  end
end
