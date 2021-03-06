class CyclesController < ApplicationController
  before_action :set_cycle, only: [:show, :edit, :update, :destroy]
  before_action :set_incident

  def index
    @cycles = @incident.cycles.load
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        @draft = true
        naming = PdfNaming.draft(@cycle)
        render pdf: naming.ics202,
          template: "cycles/show.pdf.erb",
          layout: "application"
      end
    end
  end

  def new
    if params.has_key?(:cycle)
      @cycle = Forms::Form202.new cycle_params
    else
      dates_range = Cycle.next_dates_limits_to @incident
      @cycle = Forms::Form202.new number: Cycle.next_number_to(@incident),
        from: dates_range.begin,
        to: dates_range.end
    end

    @from_is_mandatory = Cycle.next_have_ending_mandatory?(@incident)
    last_cycle = @incident.cycles.last
    @last_cycle = Forms::Form202.new_from(last_cycle) if last_cycle
  end

  def edit
    @cycle = Forms::Form202.new_from(@cycle)
    prepare_to_render_edit_form
  end

  def create
    @cycle = Forms::Form202.new(cycle_params)
    @cycle.incident = @incident
    @cycle.owner = current_user

    respond_to do |format|
      if @cycle.save
        notice_msg = "Operational Period #{@cycle.number} was successfully created."
        format.html { redirect_to incident_cycles_path(@incident), notice: notice_msg }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @cycle = Forms::Form202.new_from(@cycle)
    @cycle.incident = @incident
    @cycle.owner = current_user
    @cycle.update_with(cycle_params)

    respond_to do |format|
      if @cycle.save
        notice_msg = "Incident Objectives of Operational Period #{@cycle.number} was successfully updated."
        format.html { redirect_to incident_cycles_path(@incident), notice: notice_msg }
      else
        prepare_to_render_edit_form
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @cycle.destroy
    respond_to do |format|
      format.html { redirect_to incident_cycles_url(@incident) }
    end
  end

  private
    def set_cycle
      @cycle = Cycle.find(params[:id])
      @form202 = Forms::Form202.new_from(@cycle)
    end

    def set_incident
      @incident = Incident.find(params[:incident_id])
    end

    def cycle_params
      cycle_params = params.require(:cycle).permit(:number, :from, :to, :priorities)
      cycle_params[:objectives_texts] = params[:objectives_texts] || []
      Forms::Form202.normalize(cycle_params)
    end

    def prepare_to_render_edit_form
    permission = GroupPermission.new(::Model.root)
    @can_create_and_delete = permission.to_create? current_user
    end
end
