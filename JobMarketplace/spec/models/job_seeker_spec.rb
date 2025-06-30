require 'rails_helper'

RSpec.describe JobSeeker, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:job_applications).inverse_of(:job_seeker).dependent(:destroy) }
  end
end
