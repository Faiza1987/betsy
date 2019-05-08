# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = [
  ["laneiam", "laneia@email.com"],
  ["faiza", "faiza@email.com"],
  ["amyw", "amy@email.com"],
  ["elise", "elise@email.com"],
  ["tildee", "tildee@email.com"],
]

users.each do |username, email|
  User.create(
    username: username,
    email: email,
  )
end

categories = [
  ["NSFW"],
  ["SFW"],
  ["Messy"],
  ["Clean"],
  ["Edible"],
]

categories.each do |name|
  Category.create(
    name: name,
  )
end

Product.create!(name: "Bag of Dicks",
                price: 10,
                stock: 200,
                description: "Eat it.",
                photo_url: "https://i.imgur.com/eOJJDuE.jpg",
                user_id: rand(1..5),
                category_ids: ["NSFW", "Edible"])

Product.create!(name: "Glitter Bomb",
                price: 5,
                stock: 200,
                description: "Show them how much you care with the gift that keeps on giving, long after they wish it wouldn't.",
                photo_url: "https://i.imgur.com/iWsCjox.jpg",
                user_id: rand(1..5),
                category_ids: ["SFW", "Messy"])

Product.create!(name: "Drop a Deuce (in their mailbox)",
                price: 25,
                stock: 200,
                description: "When you just can't give a shit anymore, we can do it for you.",
                photo_url: "https://i.imgur.com/p6As6x8.jpg",
                user_id: rand(1..5),
                category_ids: ["SFW", "Messy"])

Product.create!(name: "Forbidden Lollipops",
                price: 5,
                stock: 200,
                description: "Hand dipped in the finest fruity wax candles.",
                photo_url: "https://i.imgur.com/N0Gyp1f.jpg",
                user_id: rand(1..5),
                category_ids: ["SFW"])

Product.create!(name: "Chocolate Anaconda",
                price: 5,
                stock: 200,
                description: "Guaranteed to taste delicious even if you don't got buns, hun.",
                photo_url: "https://i.imgur.com/xP3MtfZ.jpg",
                user_id: rand(1..5),
                category_ids: ["NSFW", "Edible"])
