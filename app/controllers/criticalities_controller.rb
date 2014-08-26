class CriticalitiesController < ApplicationController
  def update
    group = Group.find(params[:group_id])
    group_params = {criticality: params[:value]}
    group.update_attributes(group_params)

    respond_to do |format|
      @groups = Group.where(name: ::Model.tactic.name).load
      format.json {render :index}
    end
  end
end
