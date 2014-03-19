class CyclesController < ApplicationController
  before_action :set_cycle, only: [:show, :edit, :update, :destroy]
  before_action :set_incident

  def index
    @cycles = @incident.cycles.all
  end

  def show
  end

  def new
    @cycle = Forms::Form202.new
  end

  def edit
    @cycle = Forms::Form202.new_from(@cycle)
  end

  def create
    @cycle = Forms::Form202.new(cycle_params)
    @cycle.owner = current_user
    @cycle.incident = @incident

    respond_to do |format|
      if @cycle.save
        format.html { redirect_to incident_cycle_analysis_matrix_path(@incident, @cycle), notice: 'The cycle was successfully registered.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @cycle = Forms::Form202.new_from(@cycle)
    @cycle.incident = @incident
    @cycle.update_with(cycle_params)

    respond_to do |format|
      if @cycle.save
        format.html { redirect_to incident_cycles_path(@incident), notice: 'The cycle was successfully updated.' }
      else
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
    end

    def set_incident
      @incident = Incident.find(params[:incident_id])
    end

    def cycle_params
      cycle_params = params.require(:cycle).permit(:number, :from, :to, :objectives_text, :priorities)
      flatter = StandardLib::HashFlatter.new(cycle_params)
      flatter.flatten("from"){|values| DateTime.new(*values.map(&:to_i))}
      flatter.flatten("to"){|values| DateTime.new(*values.map(&:to_i))}
      flatter.hash
    end
end
