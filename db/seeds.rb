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


if Field.count.zero?
  puts "Seeding campi demo…"

  demo_fields = [
    { nome: "Campo Corso",  descrizione: "Erba sintetica, luci serali", sport: "Calcio",  prezzo: 50,
      via: "Via del Corso 1",  cap: "00186", citta: "Roma",
      start_time: "09:00", end_time: "22:00", interval: 60, exclude_days: [] },

    { nome: "Campo Navona", descrizione: "Ottimo per tennis singolo/doppio", sport: "Tennis", prezzo: 40,
      via: "Piazza Navona 10", cap: "00186", citta: "Roma",
      start_time: "09:00", end_time: "22:00", interval: 60, exclude_days: [] },

    { nome: "Campo Traste", descrizione: "Parquet indoor", sport: "Basket", prezzo: 35,
      via: "Viale Trastevere", cap: "00153", citta: "Roma",
      start_time: "09:00", end_time: "22:00", interval: 60, exclude_days: [] }
  ]

  demo_fields.each do |attrs|
    f = Field.create!(attrs)
    # forziamo geocoding immediato (oltre al callback) ed evitiamo blocchi di validazione
    f.geocode
    f.save!(validate: false)
  end

  puts "Creati #{Field.count} campi demo."
else
  puts "Campi già presenti: #{Field.count}."
end
