categories = []
5.times do |n|
  name = Faker::Name.name + "-#{n+1}"
  parent_id = n > 0 ? categories[n - 1].id : nil
  categories << Category.create!(name: name,
    parent_id: parent_id)
end

users = []
99.times do |n|
  name  = Faker::Name.name
  email = "user5-#{n+1}@gmail.com"
  password = "password"
  phone = "123456789"
  address = "Da Nang"
  avatar = "avatar.png"
  role = 1
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
99.times do |n|
  name  = Faker::Name.name
  description = Faker::Commerce.department
  quantity = Faker::Number.between(10, 100)
  price = Faker::Number.between(10, 100)
  category = categories.sample.id
  rating = Faker::Number.between(10, 50).to_f / 10
  view = Faker::Number.between(10, 100)
  discount = Faker::Number.between(10, 50).to_f / 10
  user = users.sample.id
  products << Product.create!(name: name,
    description: description,
    quantity: quantity,
    price: price,
    category_id: category,
    rating: rating,
    discount: discount,
    user_id: user)
end
