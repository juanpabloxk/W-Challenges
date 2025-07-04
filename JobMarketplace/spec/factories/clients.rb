# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string
#
FactoryBot.define do
  factory :client do
    name { Faker::Company.name }
    email { Faker::Internet.email }
  end
end
