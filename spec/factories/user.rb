FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.free_email}
    password {"password"}
    password_confirmation {"password"}
    phone {Faker::PhoneNumber.cell_phone_with_country_code}
    address {Faker::Address.full_address}
    avatar {Faker::Avatar.image}
    role {User.roles[:customer]}
    confirmed_at {Time.now}
  end

  factory :admin, class: User do
    name {Faker::Name.name}
    email {Faker::Internet.free_email}
    password {"password"}
    password_confirmation {"password"}
    phone {Faker::PhoneNumber.cell_phone_with_country_code}
    address {Faker::Address.full_address}
    avatar {Faker::Avatar.image}
    role {User.roles[:admin]}
    confirmed_at {Time.now}
  end
end
