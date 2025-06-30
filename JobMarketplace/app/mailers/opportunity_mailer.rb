# frozen_string_literal: true

# Mailer for job applications
class OpportunityMailer < ApplicationMailer
  def application_received(job_application)
    @job_application = job_application
    @opportunity = job_application.opportunity
    @job_seeker = job_application.job_seeker
    @client = @opportunity.client

    mail(to: @client.email, subject: "New job application received for #{@opportunity.title}")
  end
end
