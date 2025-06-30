FactoryBot.define do
  factory :job_seeker do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
  end
end
