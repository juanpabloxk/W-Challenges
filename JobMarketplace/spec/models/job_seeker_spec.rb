# == Schema Information
#
# Table name: job_seekers
#
#  id         :bigint           not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe JobSeeker, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:job_applications).inverse_of(:job_seeker).dependent(:destroy) }
  end
end
