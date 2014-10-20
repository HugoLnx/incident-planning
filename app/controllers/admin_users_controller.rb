class AdminUsersController < ApplicationController
  def index
    @users = User.order(:created_at).load
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        destroy_unused_companies
        format.html { redirect_to admin_users_path, notice: 'The user was successfully updated.' }
      else
        format.html { redirect_to admin_users_path, alert: 'Error on user update.' }
      end
    end
  end

private
  def user_params
    uparams = params.require(:user).permit(:company_id, :company_name)
    name = uparams.delete(:company_name)
    comp_id = uparams[:company_id]
    if (comp_id && comp_id.empty?) || comp_id.nil?
      company = Company.find_or_create_by(name: name)
      uparams[:company_id] = company.id
    end
    uparams
  end

  def destroy_unused_companies
    Company.destroy(Company.all - Company.joins(:users).where("users.company_id = companies.id"))
  end
end
