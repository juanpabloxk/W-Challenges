# == Schema Information
#
# Table name: opportunities
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :text
#  salary      :decimal(, )
#  client_id   :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :opportunity do
    title { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    salary { Faker::Number.between(from: 80000, to: 200000) }
    association :client
  end
end
