# frozen_string_literal: true

require 'rspec'
require_relative '../rate_limiter'

# rubocop:disable Metrics/BlockLength

RSpec.describe RateLimiter do
  let(:time_window) { 30 }
  let(:max_requests) { 3 }
  let(:rate_limiter) { described_class.new(time_window, max_requests) }

  describe '#allow_request?' do
    context 'when user has no previous requests' do
      it 'allows the first request' do
        expect(rate_limiter.allow_request?(1_700_000_010, 1)).to be true
      end

      it 'allows multiple first requests for different users' do
        expect(rate_limiter.allow_request?(1_700_000_010, 1)).to be true
        expect(rate_limiter.allow_request?(1_700_000_011, 2)).to be true
        expect(rate_limiter.allow_request?(1_700_000_012, 3)).to be true
      end
    end

    context 'when user has more than one request within the time window' do
      before do
        rate_limiter.allow_request?(1_700_000_010, 1)
        rate_limiter.allow_request?(1_700_000_011, 1)
      end

      it 'allows the third request within limit' do
        expect(rate_limiter.allow_request?(1_700_000_012, 1)).to be true
      end

      it 'denies the fourth request when limit is exceeded' do
        rate_limiter.allow_request?(1_700_000_012, 1)
        expect(rate_limiter.allow_request?(1_700_000_012, 1)).to be false
      end
    end

    context 'sliding window behavior' do
      before do
        rate_limiter.allow_request?(1_700_000_010, 1) # 2023-11-14 17:13:30 -0500
        rate_limiter.allow_request?(1_700_000_015, 1) # 2023-11-14 17:13:35 -0500
        rate_limiter.allow_request?(1_700_000_020, 1) # 2023-11-14 17:13:40 -0500
      end

      it 'denies request when at limit' do
        expect(rate_limiter.allow_request?(1_700_000_025, 1)).to be false # 2023-11-14 17:13:45 -0500
      end

      it 'allows new request after oldest request expires' do
        # (31 seconds later: 2023-11-14 17:14:01 -0500)
        expect(rate_limiter.allow_request?(1_700_000_041, 1)).to be true
      end

      it 'allows multiple requests as window slides' do
        expect(rate_limiter.allow_request?(1_700_000_045, 1)).to be true # 2023-11-14 17:14:05 -0500
        expect(rate_limiter.allow_request?(1_700_000_050, 1)).to be true # 2023-11-14 17:14:10 -0500
        expect(rate_limiter.allow_request?(1_700_000_055, 1)).to be true # 2023-11-14 17:14:15 -0500
        expect(rate_limiter.allow_request?(1_700_000_060, 1)).to be false # 2023-11-14 17:14:20 -0500
      end
    end

    context 'multiple users' do
      it 'tracks requests separately for each user' do
        expect(rate_limiter.allow_request?(1_700_000_010, 1)).to be true # 2023-11-14 17:13:30 -0500
        expect(rate_limiter.allow_request?(1_700_000_015, 1)).to be true # 2023-11-14 17:13:35 -0500
        expect(rate_limiter.allow_request?(1_700_000_020, 1)).to be true # 2023-11-14 17:13:40 -0500
        expect(rate_limiter.allow_request?(1_700_000_025, 1)).to be false # 2023-11-14 17:13:45 -0500

        expect(rate_limiter.allow_request?(1_700_000_030, 2)).to be true # 2023-11-14 17:13:50 -0500
        expect(rate_limiter.allow_request?(1_700_000_035, 2)).to be true # 2023-11-14 17:13:55 -0500
        expect(rate_limiter.allow_request?(1_700_000_040, 2)).to be true # 2023-11-14 17:14:00 -0500
        expect(rate_limiter.allow_request?(1_700_000_045, 2)).to be false # 2023-11-14 17:14:05 -0500
      end

      it 'manages intercalated requests' do
        requests = [
          { timestamp: 1_700_000_010, user_id: 1 },
          { timestamp: 1_700_000_011, user_id: 2 },
          { timestamp: 1_700_000_020, user_id: 1 },
          { timestamp: 1_700_000_035, user_id: 1 },
          { timestamp: 1_700_000_040, user_id: 1 }
        ]

        results = []
        requests.each do |request|
          allowed = rate_limiter.allow_request?(request[:timestamp], request[:user_id])
          results << { timestamp: request[:timestamp], user_id: request[:user_id], allowed: allowed }
        end

        # Expected results based on 3 requests per 30 seconds
        expect(results[0][:allowed]).to be true
        expect(results[1][:allowed]).to be true
        expect(results[2][:allowed]).to be true
        expect(results[3][:allowed]).to be true
        expect(results[4][:allowed]).to be false
      end
    end

    context 'edge cases' do
      it 'handles requests with same timestamp' do
        expect(rate_limiter.allow_request?(1_700_000_010, 1)).to be true
        expect(rate_limiter.allow_request?(1_700_000_010, 1)).to be true
        expect(rate_limiter.allow_request?(1_700_000_010, 1)).to be true
        expect(rate_limiter.allow_request?(1_700_000_010, 1)).to be false
      end

      it 'handles decreasing timestamps' do
        expect(rate_limiter.allow_request?(1_700_000_020, 1)).to be true
        expect(rate_limiter.allow_request?(1_700_000_010, 1)).to be true
        expect(rate_limiter.allow_request?(1_700_000_015, 1)).to be true
        expect(rate_limiter.allow_request?(1_700_000_025, 1)).to be false
      end
    end

    context 'performance expectations' do
      it 'handles many users efficiently' do
        # Test with 1000 different users
        1000.times do |user_id|
          expect(rate_limiter.allow_request?(1_700_000_010, user_id)).to be true
        end

        # A new user can still make requests
        expect(rate_limiter.allow_request?(1_700_000_040, 1001)).to be true
        expect(rate_limiter.allow_request?(1_700_000_045, 1001)).to be true
        expect(rate_limiter.allow_request?(1_700_000_050, 1001)).to be true
      end
    end

    context 'different configurations' do
      it 'with 1 request per 10 seconds' do
        limiter = described_class.new(10, 1)
        expect(limiter.allow_request?(1_700_000_010, 1)).to be true
        expect(limiter.allow_request?(1_700_000_015, 1)).to be false
        expect(limiter.allow_request?(1_700_000_021, 1)).to be true
      end

      it 'with 5 requests per 60 seconds' do
        limiter = described_class.new(60, 5)
        5.times do |i|
          expect(limiter.allow_request?(1_700_000_010 + i, 1)).to be true
        end
        5.times do |i|
          expect(limiter.allow_request?(1_700_000_010 + i, 1)).to be false
        end
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
