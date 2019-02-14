# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

  if Role.find_by(name: :superadmin).nil?
    user_sadmin = User.new(username: "superadmin", email: "superadmin@searcheng.in", password: "superadmin1234", password_confirmation: "superadmin1234", first_name: "Super", last_name: "Admin")
    user_sadmin.save(validate: false)
    user_sadmin.add_role :superadmin
  end

  if Role.find_by(name: :admin).nil?
    user_admin = User.new(username: "admin", email: "admin@searcheng.in", password: "admin1234", password_confirmation: "admin1234", first_name: "Admin", last_name: "Admin")
    user_admin.save(validate: false)
    user_admin.add_role :editor
  end

  if Role.find_by(name: :editor).nil?
    user_editor = User.new(username: "editor", email: "editor@searcheng.in", password: "editor1234", password_confirmation: "editor1234", first_name: "Editor", last_name: "Editor")
    user_editor.save(validate: false)
    user_editor.add_role :editor
  end
