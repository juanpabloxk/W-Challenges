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
FactoryBot.define do
  factory :job_seeker do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
  end
end
