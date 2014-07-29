class ApprovalsController < ApplicationController
  def create
    expression = PolymorphicFinder.find(approval_params[:expression_id], approval_params[:expression_type])
    approvals = Approval.build_all_to(current_user, positive: approval_params[:positive], approve: expression)
    approvals = ApprovalCollection.new(approvals)

    respond_to do |format|
      if approvals.save
        cycle = expression.cycle
        format.html {redirect_to general_back_path, notice: "Expression was sucessfuly approved."}
      else
        format.html {render status: :not_implemented, text: "Error, approval was not saved and this case was not treated yet"}
      end
    end
  end

private
  def approval_params
    params.require(:approval).permit(:expression_id, :expression_type, :positive)
  end
end
