class JobApplicationNotificationJob < ApplicationJob
  queue_as :default

  def perform(job_application)
    # In a real app, we would send an email or push notification here.
    # For now, we'll just log to the console.
    puts "Sending notification for job application ##{job_application.id}"
  end
end
