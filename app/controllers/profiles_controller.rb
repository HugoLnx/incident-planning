class ProfilesController < ApplicationController
  def index
    @filter_term = params[:filter]
    @filter_term = nil if @filter_term && @filter_term.empty?
    if @filter_term
      @users = QueryFilter.new(User.all).filter(@filter_term, by: %w{name email}).load
    else
      @users = []
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @user = User.find params[:id]
  end
end
