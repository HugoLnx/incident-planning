class PublishesController < ApplicationController
  before_filter :set_incident_and_cycle

  def publish
    prepare_to_render_analysis_matrix

    all_messages = Publish::PublishValidation.errors_messages_on(@objectives)
    @expression_errors = all_messages[:expression]
    @group_errors = all_messages[:group]

    if !Publish::ValidationUtils.have_errors?(all_messages)
      Publish::Publisher.publish(@cycle, ics234_pdf: render_matrix_pdf, ics202_pdf: render_objectives_pdf)
      redirect_to action: :show
    else
      render "analysis_matrices/show"
    end
  end

  def new
    prepare_to_render_analysis_matrix

    all_errors = Publish::PublishValidation.errors_messages_on(@objectives)
    @expression_errors = all_errors[:expression]
    @group_errors = all_errors[:group]

    render "analysis_matrices/show"
  end

  def show
    prepare_to_render_analysis_matrix
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
