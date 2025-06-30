require 'rails_helper'

RSpec.describe "Api::V1::Opportunities", type: :request do
  describe "GET /api/v1/opportunities" do
    let!(:client) { create(:client) }
    let!(:opportunities) { create_list(:opportunity, 15, client: client) }

    it "returns a paginated list of opportunities" do
      get "/api/v1/opportunities"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['opportunities'].size).to eq(10)
      expect(json_response['pagy']['count']).to eq(15)
    end

    it "returns a successful response with client name" do
      get "/api/v1/opportunities"
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['opportunities'].first['client']['name']).to eq(client.name)
    end

    it 'filters opportunities by title' do
      create(:opportunity, title: 'Unique Title for Search')
      get '/api/v1/opportunities', params: { query: 'Unique Title' }

      json_response = JSON.parse(response.body)
      expect(json_response['opportunities'].size).to eq(1)
      expect(json_response['opportunities'].first['title']).to eq('Unique Title for Search')
    end
  end

  describe "POST /api/v1/opportunities" do
    let(:client) { create(:client) }
    let(:valid_attributes) do
      {
        opportunity: {
          title: "New Opportunity",
          description: "A great new job.",
          salary: 120000,
          client_id: client.id
        }
      }
    end

    it "creates a new opportunity" do
      expect {
        post "/api/v1/opportunities", params: valid_attributes
      }.to change(Opportunity, :count).by(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq("New Opportunity")
    end

    it 'returns unprocessable_entity for invalid data' do
      post '/api/v1/opportunities', params: { opportunity: { title: '' } }
      expect(response).to have_http_status(422)
    end
  end

  describe "POST /api/v1/opportunities/:id/apply" do
    let(:opportunity) { create(:opportunity) }
    let(:job_seeker) { create(:job_seeker) }
    let(:valid_attributes) do
      {
        job_application: {
          job_seeker_id: job_seeker.id
        }
      }
    end

    it "creates a new job application and enqueues a job" do
      expect {
        post "/api/v1/opportunities/#{opportunity.id}/apply", params: valid_attributes
      }.to change(JobApplication, :count).by(1).and have_enqueued_job(JobApplicationNotificationJob)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to include("Application successful!")
    end

    it 'returns unprocessable_entity for invalid data' do
      post "/api/v1/opportunities/#{opportunity.id}/apply", params: { job_application: { job_seeker_id: nil } }
      expect(response).to have_http_status(422)
    end
  end
end
