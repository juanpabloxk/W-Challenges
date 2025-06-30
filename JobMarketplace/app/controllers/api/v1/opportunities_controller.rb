class Api::V1::OpportunitiesController < ApplicationController
  def index
    cache_key = "opportunities-#{params[:query]}-#{params[:page]}"

    cached_data = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      scope = Opportunity.includes(:client)
      if params[:query].present?
        scope = scope.where("title ILIKE ?", "%#{params[:query]}%")
      end

      pagy, opportunities = pagy(scope, items: 10)
      {
        opportunities: opportunities.as_json(include: { client: { only: [:id, :name] } }),
        pagy: pagy.as_json
      }
    end

    render json: cached_data
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
    job_application = opportunity.job_applications.build(job_application_params)

    if job_application.save
      JobApplicationNotificationJob.perform_later(job_application)
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
    params.require(:job_application).permit(:job_seeker_id)
  end
end
