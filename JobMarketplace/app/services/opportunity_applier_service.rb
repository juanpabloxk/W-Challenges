# frozen_string_literal: true

# Service to fetch opportunities
class OpportunityApplierService < ApplicationService
  # @param [Opportunity] opportunity
  # @param [Hash] params
  # @option params [String] :job_seeker_name
  # @option params [String] :job_seeker_email
  def initialize(opportunity, params)
    @params = params
    @opportunity = opportunity
  end

  def call
    job_seeker = JobSeeker.find_or_create_by!(name: @params[:job_seeker_name], email: @params[:job_seeker_email])

    if @opportunity.job_applications.find_by(job_seeker: job_seeker).present?
      return [ { errors: "Job application already exists, please wait for the application to be processed." }, :unprocessable_entity ]
    end

    job_application = @opportunity.job_applications.build(job_seeker: job_seeker)

    if job_application.save
      JobApplicationNotificationJob.perform_later(job_application)
      [ { message: "Application successful! Your application is being processed." }, :created ]
    else
      [ { errors: job_application.errors.full_messages }, :unprocessable_entity ]
    end
  end
end
