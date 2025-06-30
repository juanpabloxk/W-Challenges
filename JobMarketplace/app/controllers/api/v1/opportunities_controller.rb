class Api::V1::OpportunitiesController < ApplicationController
  def index
    opportunities_data = OpportunitiesFetcherService.new(params).call
    render json: opportunities_data
  end

  def create
    opportunity = Opportunity.new(opportunity_params)

    if opportunity.save
      render json: opportunity, status: :created
    else
      render json: { errors: opportunity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def apply
    opportunity = Opportunity.find(params[:id])
    job_application = OpportunityApplierService.new(opportunity, job_application_params).call

    if job_application.persisted?
      render json: { message: "Application successful! Your application is being processed." }, status: :created
    else
      render json: { errors: job_application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def opportunity_params
    params.require(:opportunity).permit(:title, :description, :salary, :client_id)
  end

  def job_application_params
    params.require(:job_application).permit(:job_seeker_name, :job_seeker_email)
  end
end
