class VersionsController < ApplicationController
  before_filter :set_incident_and_cycle

  def create
    prepare_to_render_analysis_matrix

    all_errors = Publish::VersionValidation.errors_on(@objectives)
    @expression_errors = Publish::ValidationUtils.get_messages(all_errors[:expression])
    @group_errors = Publish::ValidationUtils.get_messages(all_errors[:group])
    @group_errors = Publish::GroupMessagesIterator.new(@group_errors)

    if @expression_errors.empty? && @group_errors.empty?
      Publish::Version.issue(@cycle, render_matrix_pdf)
      redirect_to controller: :analysis_matrices, action: :show
    else
      render "analysis_matrices/show"
    end
  end

  def new
    prepare_to_render_analysis_matrix

    all_errors = Publish::VersionValidation.errors_on(@objectives)
    @expression_errors = Publish::ValidationUtils.get_messages(all_errors[:expression])
    @group_errors = Publish::ValidationUtils.get_messages(all_errors[:group])
    @group_errors = Publish::GroupMessagesIterator.new(@group_errors)

    render "analysis_matrices/show"
  end

  def index
    @versions = @cycle.versions
  end

  def show
    version = Version.find(params[:id])
    respond_to do |format|
      format.pdf {render text: version.pdf}
    end
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
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
    render_to_string pdf: "anything",
      template: "analysis_matrices/show.pdf.erb",
      layout: "application"
  end
end
