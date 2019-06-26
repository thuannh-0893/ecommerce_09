FactoryBot.define do
  factory :order do
    receiver_name {Faker::Name.name}
    receiver_phone {Faker::PhoneNumber.cell_phone_with_country_code}
    receiver_address {Faker::Address.full_address}
    total_price {1000}
    description {Faker::Food.description}
    user_id {2}
  end
end