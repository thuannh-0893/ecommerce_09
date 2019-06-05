categories = []
15.times do |n|
  name = Faker::Lorem.word + Faker::Lorem.word
  parent_id = n > 5 ? Faker::Number.between(1, 5) : nil
  categories << Category.create!(name: name,
    parent_id: parent_id)
end

User.create!(name: "Admin Account",
  email: "admin@example.com",
  password: "admin123",
  password_confirmation: "admin123",
  phone: "0123456789",
  address: "Da Nang",
  avatar: "",
  role: 1)

users = []
50.times do |n|
  name  = Faker::Name.name
  email = Faker::Internet.free_email
  password = "password"
  phone = Faker::PhoneNumber.cell_phone_with_country_code
  address = Faker::Address.full_address
  avatar = Faker::Avatar.image
  role = 0
  users << User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    phone: phone,
    address: address,
    avatar: avatar,
    role: role)
end


products = []
50.times do |n|
  name  = Faker::Lorem.sentence
  picture = Faker::LoremFlickr.image
  description = Faker::Marketing.buzzwords
  quantity = Faker::Number.between(10, 200)
  price = Faker::Number.between(10, 500)
  category_id = Faker::Number.between(6, 15)
  rating = Faker::Number.between(10, 50).to_f / 10
  view = Faker::Number.between(100, 1000)
  discount = Faker::Number.between(5, 70)
  user = users.sample.id
  products << Product.create!(name: name,
    description: description,
    quantity: quantity,
    price: price,
    category_id: category_id,
    rating: rating,
    discount: discount,
    user_id: user)
end
