class AnalysisMatricesController < ApplicationController
  before_filter :set_incident_and_cycle

  def show
    if @cycle.closed?
      redirect_to incident_cycle_publishes_path(@incident, @cycle)
    else
      prepare_to_render_analysis_matrix(@cycle)
      respond_to do |format|
        format.html
        format.pdf do
          @draft = true
          naming = PdfNaming.draft(@cycle)
          render pdf: naming.ics234,
            template: "analysis_matrices/show.pdf.erb",
            layout: "application"
        end
      end
    end
  end

  def group_approval
    prepare_to_render_analysis_matrix(@cycle)

    render "show_group_approval"
  end

  def group_deletion
    prepare_to_render_analysis_matrix(@cycle)

    render "show_group_deletion"
  end

private
  def set_incident_and_cycle
    @incident = Incident.find params[:incident_id]
    @cycle = Cycle.find params[:cycle_id]
  end
end
