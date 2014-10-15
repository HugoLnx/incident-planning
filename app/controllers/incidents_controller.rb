class IncidentsController < ApplicationController
  before_action :set_incident, only: [:show, :edit, :update, :destroy]

  def index
    @incidents = Incident.where("company_id = ? or company_id is null", current_user.company_id)
  end

  def show
  end

  def new
    @incident = Incident.new
  end

  def edit
  end

  def create
    @incident = Incident.new(incident_params)

    respond_to do |format|
      if @incident.save
        format.html { redirect_to new_incident_cycle_path(@incident), notice: 'The incident was successfully registered.' }
        format.json { render action: 'show', status: :created, location: @incident }
      else
        format.html { render action: 'new' }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @incident.update(incident_params)
        format.html { redirect_to @incident, notice: 'The incident was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @incident.destroy
    respond_to do |format|
      format.html { redirect_to incidents_url }
      format.json { head :no_content }
    end
  end

  private
    def set_incident
      @incident = Incident.find(params[:id])
    end

    def incident_params
      attrs = params.require(:incident).permit(:name, :public)
      if !attrs.delete(:public)
        attrs[:company_id] = current_user.company_id
      end
      attrs
    end
end
