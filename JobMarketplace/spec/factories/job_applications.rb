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
FactoryBot.define do
  factory :job_application do
    association :opportunity
    association :job_seeker
  end
end
