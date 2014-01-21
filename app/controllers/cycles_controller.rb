class CyclesController < ApplicationController
  before_action :set_cycle, only: [:show, :edit, :update, :destroy]
  before_action :set_incident

  def index
    @cycles = Cycle.all
  end

  def show
  end

  def new
    @cycle = Cycle.new
  end

  def create
    @cycle = Cycle.new(cycle_params)
    @cycle.incident = @incident

    respond_to do |format|
      if @cycle.save
        format.html { redirect_to incident_cycles_path(@incident), notice: 'The cycle was successfully registered.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @cycle.update(cycle_params)
        format.html { redirect_to incident_cycles_path(@incident), notice: 'The cycle was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @cycle.destroy
    respond_to do |format|
      format.html { redirect_to cycles_url }
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
      cycle_params = params.require(:cycle).permit(:number, :from, :to)
    end
end
