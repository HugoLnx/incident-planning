class CompaniesController < ApplicationController
  def index
    companies = Company.all
    respond_to do |format|
      format.json{ render json: companies }
    end
  end
end
