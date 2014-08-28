class ProfilesController < ApplicationController
  def index
    @users = QueryFilter.new(User.all).filter(@filter_term, by: %w{name email}).load
  end
end
