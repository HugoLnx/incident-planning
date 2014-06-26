class GroupDeletionsController < ApplicationController
  def destroy
    params.permit(:groups, :incident_id, :cycle_id)
    groups_ids = params[:groups]
    Group.destroy_all(id: groups_ids)

    respond_to do |format|
      path_to_matrix = incident_cycle_analysis_matrix_path(params[:incident_id], params[:cycle_id])
      format.html {redirect_to(path_to_matrix, notice: "Expressions were sucessfuly deleted.")}
    end
  end
end
