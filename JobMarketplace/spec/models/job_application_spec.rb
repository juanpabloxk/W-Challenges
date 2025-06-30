# == Schema Information
#
# Table name: job_applications
#
#  id             :bigint           not null, primary key
#  opportunity_id :bigint           not null
#  job_seeker_id  :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job_seeker).inverse_of(:job_applications) }
    it { is_expected.to belong_to(:opportunity).inverse_of(:job_applications) }
  end
end
