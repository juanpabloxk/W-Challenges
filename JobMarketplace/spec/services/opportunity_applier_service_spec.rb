require 'rails_helper'

RSpec.describe OpportunityApplierService, type: :service do
  let(:opportunity) { create(:opportunity) }
  let(:job_seeker_params) { { job_seeker_name: 'Juan Pablo', job_seeker_email: 'juanp.test@example.com' } }

  describe '#call' do
    context 'with valid parameters for a new job seeker' do
      it 'creates a new job seeker' do
        expect {
          described_class.new(opportunity, job_seeker_params).call
        }.to change(JobSeeker, :count).by(1)
      end

      it 'creates a new job application' do
        expect {
          described_class.new(opportunity, job_seeker_params).call
        }.to change(JobApplication, :count).by(1)
      end

      it 'enqueues a notification job' do
        expect {
          described_class.new(opportunity, job_seeker_params).call
        }.to have_enqueued_job(JobApplicationNotificationJob)
      end

      it 'returns a success message and status' do
        message, status = described_class.new(opportunity, job_seeker_params).call
        expect(status).to eq(:created)
        expect(message[:message]).to eq('Application successful! Your application is being processed.')
      end
    end

    context 'with an existing job seeker' do
      let!(:existing_job_seeker) { create(:job_seeker, name: 'Juan Pablo', email: 'juanp.test@example.com') }

      it 'does not create a new job seeker' do
        expect {
          described_class.new(opportunity, job_seeker_params).call
        }.not_to change(JobSeeker, :count)
      end

      it 'creates a new job application for the existing seeker' do
        expect {
          described_class.new(opportunity, job_seeker_params).call
        }.to change(JobApplication, :count).by(1)
        expect(JobApplication.last.job_seeker).to eq(existing_job_seeker)
      end
    end

    context 'when a job application already exists' do
      let!(:job_seeker) { create(:job_seeker, name: 'Juan Pablo', email: 'juanp.test@example.com') }
      let!(:existing_application) { create(:job_application, opportunity: opportunity, job_seeker: job_seeker) }

      it 'does not create a new job application' do
        expect {
          described_class.new(opportunity, job_seeker_params).call
        }.not_to change(JobApplication, :count)
      end

      it 'returns an error message and status' do
        message, status = described_class.new(opportunity, job_seeker_params).call
        expect(status).to eq(:unprocessable_entity)
        expect(message[:errors]).to eq('Job application already exists, please wait for the application to be processed.')
      end
    end
  end
end
