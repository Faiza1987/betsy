# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = [
    ["laneia", "laneia@email.com"],
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
  
  