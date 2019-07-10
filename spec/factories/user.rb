FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.free_email}
    password {"password"}
    phone {Faker::PhoneNumber.cell_phone_with_country_code}
    address {Faker::Address.full_address}
    avatar {Faker::Avatar.image}
    role {User.roles[:customer]}
  end

  factory :admin do
    name {Faker::Name.name}
    email {Faker::Internet.free_email}
    password {"password"}
    phone {Faker::PhoneNumber.cell_phone_with_country_code}
    address {Faker::Address.full_address}
    avatar {Faker::Avatar.image}
    role {User.roles[:admin]}
  end
end
