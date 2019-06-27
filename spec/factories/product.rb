FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    description { Faker::Food.description }
    quantity { Faker::Number.between(10, 200) }
    price { Faker::Number.between(10, 500) }
    category
    rating { Faker::Number.between(10, 50).to_f / 10 }
    views { Faker::Number.between(100, 1000) }
    discount { Faker::Number.between(5, 70) }
    user_id { 1 }
    activated { true }
  end
end
