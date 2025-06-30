FactoryBot.define do
  factory :opportunity do
    title { Faker::Job.title }
    description { Faker::Lorem.paragraph }
    salary { Faker::Number.between(from: 80000, to: 200000) }
    association :client
  end
end
