# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Administrator.destroy_all

admin_root = Administrator.create!(
    name:                   "Root",
    surname:                "Campetto.it",
    email:                  "root@campetto.it",
    password_digest:        Administrator.digest('1q2w3e'),
    root:                   true
)
puts "Amministratore root creato: #{admin_root.email}"