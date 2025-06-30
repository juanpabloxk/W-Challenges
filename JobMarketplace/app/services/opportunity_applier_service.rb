# frozen_string_literal: true

# Service to fetch opportunities
class OpportunityApplierService
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
    job_application = @opportunity.job_applications.build(job_seeker: job_seeker)

    if job_application.save
      JobApplicationNotificationJob.perform_later(job_application)
    end

    job_application
  end
end
