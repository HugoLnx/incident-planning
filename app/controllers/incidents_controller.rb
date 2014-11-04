class IncidentsController < ApplicationController
  before_action :set_incident, only: [:show, :edit, :update, :destroy]

  def index
    @incidents = Incident.all.where_company(current_user.company_id).load
  end

  def show
  end

  def new
    @incident = Incident.new
    @companies = current_user.in_admin_company? ? Company.all.load : [current_user.company]
  end

  def edit
  end

  def create
    @incident = Incident.new(incident_params)

    respond_to do |format|
      if @incident.save
        format.html { redirect_to new_incident_cycle_path(@incident), notice: 'The incident was successfully created.' }
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
      params.require(:incident).permit(:name, :company_id)
    end
end
