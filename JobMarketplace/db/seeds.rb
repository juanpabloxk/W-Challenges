# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Force Faker to use a fixed seed for deterministic results
Faker::Config.random = Random.new(42)

# Sample clients
10.times do
  Client.find_or_create_by!(name: Faker::Company.name, email: Faker::Internet.email)
end

# Sample opportunities
20.times do |index|
  Opportunity.find_or_create_by!(
    title: Faker::Job.title,
    description: [
      "About the role:",
      Faker::Lorem.paragraph(sentence_count: 5),
      "\nResponsibilities:",
      Faker::Lorem.sentences(number: 3).map { |s| "- #{s}" }.join("\n"),
      "\nWe offer:",
      "- #{Faker::Company.bs.capitalize}.",
      "- #{Faker::Company.bs.capitalize}."
    ].join("\n"),
    salary: (index + 1) * 100_000,
    client: Client.find(index % Client.count + 1))
end
