class AdminUsersController < ApplicationController
  def index
    @users = User.order(:created_at).load
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_users_path, notice: 'The user was successfully updated.' }
      else
        format.html { redirect_to admin_users_path, alert: 'Error on user update.' }
      end
    end
  end

private
  def user_params
    params.require(:user).permit(:company_id)
  end
end
