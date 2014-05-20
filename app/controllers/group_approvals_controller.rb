class GroupApprovalsController < ApplicationController
  def create
    params.permit(:groups, :incident_id, :cycle_id)
    groups_ids = params[:groups]
    groups = Group.includes(:text_expressions, :time_expressions).find(groups_ids)
    text_expressions = groups.map(&:text_expressions).flatten
    time_expressions = groups.map(&:time_expressions).flatten

    approvals = ApprovalCollection.new
    (text_expressions + time_expressions).each do |exp|
      new_approvals = Approval.build_all_to(current_user, positive: true, approve: exp)
      approvals += new_approvals
    end

    respond_to do |format|
      if approvals.save
        path_to_matrix = incident_cycle_analysis_matrix_path(params[:incident_id], params[:cycle_id])
        format.html {redirect_to(path_to_matrix, notice: "Expressions were sucessfuly approved.")}
      else
        format.html {render status: :not_implemented, text: "Error, approvals were not saved and this case was not treated yet"}
      end
    end
  end
end
