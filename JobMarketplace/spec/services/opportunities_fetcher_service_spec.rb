require 'rails_helper'

RSpec.describe OpportunitiesFetcherService, type: :service do
  let!(:client) { create(:client) }
  let!(:opportunities) { create_list(:opportunity, 15, client: client) }

  before do
    Rails.cache.clear
  end

  describe '#call' do
    context 'without any parameters' do
      it 'returns the first page of opportunities' do
        result = described_class.new({}).call
        expect(result[:opportunities].size).to eq(10)
        expect(result[:pagination][:count]).to eq(15)
        expect(result[:opportunities].map { |opportunity| opportunity['title'] }).to eq(opportunities.first(10).map(&:title))
      end

      it 'includes client information' do
        result = described_class.new({}).call
        expect(result[:opportunities].first['client']['name']).to eq(client.name)
      end
    end

    context 'with pagination parameters' do
      it 'returns the correct page' do
        result = described_class.new({ page: 2, per_page: 5 }).call
        expect(result[:opportunities].size).to eq(5)
        expect(result[:pagination][:page]).to eq(2)
      end
    end

    context 'with query parameter' do
      let!(:specific_opportunity) { create(:opportunity, title: 'Unique Title for Search', client: client) }

      it 'filters opportunities by title' do
        result = described_class.new({ query: 'Unique Title' }).call
        expect(result[:opportunities].size).to eq(1)
        expect(result[:opportunities].first['title']).to eq('Unique Title for Search')
      end
    end
  end
end
