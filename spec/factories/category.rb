FactoryBot.define do
  factory :category do
    name { Faker::Name.name }
    parent_id { nil }
  end
end
