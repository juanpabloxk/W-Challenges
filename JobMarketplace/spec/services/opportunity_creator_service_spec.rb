require 'rails_helper'

RSpec.describe OpportunityCreatorService, type: :service do
  let(:client) { create(:client) }

  describe '#call' do
    context 'with valid parameters' do
      let(:opportunity_params) { { title: 'New Opportunity', description: 'A great job', salary: 100000, client_id: client.id } }

      it 'creates a new opportunity' do
        expect {
          described_class.new(opportunity_params).call
        }.to change(Opportunity, :count).by(1)
      end

      it 'returns a success message and status' do
        message, status = described_class.new(opportunity_params).call
        expect(status).to eq(:created)
        expect(message[:message]).to eq('Opportunity created successfully')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { title: '', description: 'A great job', salary: 100000, client_id: client.id } }

      it 'does not create a new opportunity' do
        expect {
          described_class.new(invalid_params).call
        }.not_to change(Opportunity, :count)
      end

      it 'returns an error message and status' do
        message, status = described_class.new(invalid_params).call
        expect(status).to eq(:unprocessable_entity)
        expect(message[:errors]).to eq([ "Title can't be blank" ])
      end
    end

    context 'when opportunity with the same title already exists for the client' do
      let!(:existing_opportunity) { create(:opportunity, title: 'Existing Opportunity', client: client) }
      let(:duplicate_params) { { title: 'Existing Opportunity', description: 'Another job', salary: 50000, client_id: client.id } }

      it 'does not create a new opportunity' do
        expect {
          described_class.new(duplicate_params).call
        }.not_to change(Opportunity, :count)
      end

      it 'returns an error message and status' do
        message, status = described_class.new(duplicate_params).call
        expect(status).to eq(:unprocessable_entity)
        expect(message[:errors]).to eq('Title already exists for this client. Use a different title.')
      end
    end
  end
end
