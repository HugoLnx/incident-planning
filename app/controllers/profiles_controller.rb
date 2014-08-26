class ProfilesController < ApplicationController
  def index
    if params[:commit] != "Clear"
      @filter_term = params[:filter]
    end
    @users = QueryFilter.new(User.all).filter(@filter_term, by: %w{name email}).load
  end
end
