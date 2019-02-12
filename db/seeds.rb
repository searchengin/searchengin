# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

  user = User.new(username: "admin", email: "admin@searcheng.in", password: "admin1234", password_confirmation: "admin1234", first_name: "Admin", last_name: "Admin")
  user.save(validate: false)
  user.add_role :superadmin

