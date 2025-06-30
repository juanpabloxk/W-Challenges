class JobApplicationNotificationJob < ApplicationJob
  queue_as :default

  # Discard the job if the job application is not found
  discard_on ActiveJob::DeserializationError

  def perform(job_application)
    Rails.logger.info("Sending notification for job application ##{job_application.id}")
    OpportunityMailer.application_received(job_application).deliver_later
  end
end
