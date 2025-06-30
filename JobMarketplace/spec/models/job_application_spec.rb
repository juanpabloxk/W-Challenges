require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_seeker).inverse_of(:job_applications) }
    it { is_expected.to belong_to(:opportunity).inverse_of(:job_applications) }
  end
end
