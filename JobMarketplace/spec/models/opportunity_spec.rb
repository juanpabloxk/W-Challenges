require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:client).inverse_of(:opportunities) }
    it { is_expected.to have_many(:job_applications).inverse_of(:opportunity).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:salary) }
    it { is_expected.to validate_numericality_of(:salary).is_greater_than(0) }
  end
end
