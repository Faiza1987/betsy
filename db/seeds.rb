# frozen_string_literal: true

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
  "NSFW",
  "SFW",
  "Messy",
  "Clean",
  "Edible",
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
                category_ids: [1, 5])

Product.create!(name: "Glitter Bomb",
                price: 5,
                stock: 200,
                description: "Show them how much you care with the gift that keeps on giving, long after they wish it wouldn't.",
                photo_url: "https://i.imgur.com/iWsCjox.jpg",
                user_id: rand(1..5),
                category_ids: [2, 3])

Product.create!(name: "Drop a Deuce via Mail",
                price: 25,
                stock: 200,
                description: "When you just can't give a shit anymore, we can do it for you.",
                photo_url: "https://i.imgur.com/UtsUkL7.png",
                user_id: rand(1..5),
                category_ids: [3])

Product.create!(name: "Forbidden Lollipops",
                price: 5,
                stock: 200,
                description: "Hand dipped in the finest fruity wax candles.",
                photo_url: "https://i.imgur.com/8o9Deye.png",
                user_id: rand(1..5),
                category_ids: [2])

Product.create!(name: "Chamber of Secrets",
                price: 5,
                stock: 200,
                description: "Nearly impossible to open, it is sure to turn that new package excitement right around.  What's our secret?  Nothing, it's just a USPS box.",
                photo_url: "https://i.imgur.com/J2dbefG.png",
                user_id: rand(1..5),
                category_ids: [2, 4])

Product.create!(name: "Unsolvable Rubik's Cube",
                price: 10,
                stock: 200,
                description: "For the puzzle-loving friend you clearly don't want to be friends with anymore.",
                photo_url: "https://i.imgur.com/I1iJqEy.png",
                user_id: rand(1..5),
                category_ids: [2, 4])

Product.create!(name: "Magic Trump T-Shirt",
                price: 10,
                stock: 200,
                description: "Add a little heat and things get spicy. In Spanish for a little extra boost to your Conservative relatives' blood pressure.",
                photo_url: "https://i.imgur.com/5NGq1RT.jpg",
                user_id: rand(1..5),
                category_ids: [2, 4])

Product.create!(name: "Lovely Lamp Shade",
                price: 15,
                stock: 200,
                description: "If your mom doesn't hit you with la chancla once she gets over her fear, we'll give you a full refund.",
                photo_url: "https://i.imgur.com/QcT1Ngz.png",
                user_id: rand(1..5),
                category_ids: [2])

Product.create!(name: "Tricksy T-Shirt",
                price: 25,
                stock: 200,
                description: "Put our logo on your body, ya freak.",
                photo_url: "https://i.imgur.com/XhrnBHY.png",
                user_id: rand(1..5),
                category_ids: [2, 4])
