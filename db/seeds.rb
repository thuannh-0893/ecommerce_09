sql_products = "ALTER TABLE products ADD FULLTEXT (name, description)"
ActiveRecord::Base.connection.execute(sql_products)

categories = []
15.times do |n|
  name = Faker::House.furniture + " " + Faker::House.room
  parent_id = n > 5 ? Faker::Number.between(1, 5) : nil
  categories << Category.create!(name: name,
    parent_id: parent_id)
end

User.create!(name: "Administrator",
  email: "admin@example.com",
  password: "admin123",
  password_confirmation: "admin123",
  phone: "0123456789",
  address: "Da Nang",
  avatar: "",
  role: 1,
  confirmed_at: Time.now)

products = []
50.times do |n|
  name  = Faker::Food.dish
  description = Faker::Food.description
  quantity = Faker::Number.between(10, 200)
  price = Faker::Number.between(10, 500)
  category_id = Faker::Number.between(6, 15)
  rating = Faker::Number.between(10, 50).to_f / 10
  view = Faker::Number.between(100, 1000)
  discount = Faker::Number.between(5, 70)
  user = 1
  products << Product.create!(name: name,
    description: description,
    quantity: quantity,
    price: price,
    category_id: category_id,
    rating: rating,
    discount: discount,
    user_id: user,
    activated: [true, false].sample)
  ItemPhoto.create!(product_id: (n+1), photo: "default.png")
end
