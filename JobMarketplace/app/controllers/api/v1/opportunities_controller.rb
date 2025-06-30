class Api::V1::OpportunitiesController < ApplicationController
  rescue_from Pagy::OverflowError, with: :rescue_from_pagy_overflow

  def index
    opportunities_data = OpportunitiesFetcherService.call(params)
    render json: opportunities_data
  end

  def create
    message, status = OpportunityCreatorService.call(opportunity_params)
    render json: message, status: status
  end

  def apply
    opportunity = Opportunity.find(params[:id])
    message, status = OpportunityApplierService.call(opportunity, job_application_params)
    render json: message, status: status
  end

  private

  def opportunity_params
    params.require(:opportunity).permit(:title, :description, :salary, :client_id)
  end

  def job_application_params
    params.require(:job_application).permit(:job_seeker_name, :job_seeker_email)
  end

  def rescue_from_pagy_overflow(exception)
    render json: { error: "That page does not exist. #{exception.message}" }, status: :not_found
  end
end
