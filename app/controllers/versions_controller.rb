class VersionsController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    prepare_to_render_analysis_matrix

    all_messages = Publish::VersionValidation.errors_messages_on(@objectives)
    @expression_errors = all_messages[:expression]
    @group_errors = all_messages[:group]

    if !Publish::ValidationUtils.have_errors?(all_messages)
      Publish::Version.issue(@cycle, ics234_pdf: render_matrix_pdf, ics202_pdf: render_objectives_pdf)
      redirect_to controller: :analysis_matrices, action: :show
    else
      render "analysis_matrices/show"
    end
  end

  def new
    prepare_to_render_analysis_matrix

    all_messages = Publish::VersionValidation.errors_messages_on(@objectives)
    @expression_errors = all_messages[:expression]
    @group_errors = all_messages[:group]

    render "analysis_matrices/show"
  end

  def index
    @versions = @cycle.versions
  end

  def show_ics234
    version = Version.find(params[:id])
    respond_to do |format|
      naming = PdfNaming.new(@cycle, @cycle.current_version_number, extension: true)
      format.pdf {send_data version.ics234_pdf, filename: naming.ics234}
    end
  end

  def show_ics202
    version = Version.find(params[:id])
    respond_to do |format|
      naming = PdfNaming.new(@cycle, @cycle.current_version_number, extension: true)
      format.pdf {send_data version.ics202_pdf, filename: naming.ics202}
    end
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
    @form202 = Forms::Form202.new_from(@cycle)
  end

  def prepare_to_render_analysis_matrix
    dao = Dao::AnalysisMatrixDao.new(@cycle)
    @objectives = dao.find_all_objectives_including_hierarchy
    @matrix_data = AnalysisMatrixData.new(@objectives)

    @objective = ::Model.objective
    @strategy = ::Model.strategy
    @tactic = ::Model.tactic
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
