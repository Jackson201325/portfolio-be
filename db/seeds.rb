# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.find_or_create_by!(name: "Web client", redirect_uri: "", scopes: "")
  Doorkeeper::Application.find_or_create_by!(name: "Mobile client", redirect_uri: "", scopes: "")
end

me = User.find_or_create_by!(email: "jackson@test.com", password: "blackjack21")

10.times do
  listing = Listing.find_or_create_by!(title: Faker::Vehicle.make_and_model) do |listing|
    listing.host = me
    listing.about = Faker::Lorem.paragraph
    listing.max_guests = rand(1..5)
    listing.address_line1 = Faker::Address.street_address
    listing.city = Faker::Address.city
    listing.state = Faker::Address.state
    listing.country = "US"
    listing.status = :published
    listing.nightly_price = rand(1..100)
    listing.nightly_price = rand(1..20)
  end
end

10.times do
  host_user = User.find_or_create_by!(email: Faker::Internet.email) do |user|
    user.password = Faker::Internet.password
    user.email = Faker::Internet.email
    user.name = Faker::Games::LeagueOfLegends.champion
  end

  10.times do
    listing = Listing.find_or_create_by!(title: Faker::Vehicle.make_and_model) do |listing|
      listing.host = host_user
      listing.about = Faker::Lorem.paragraph
      listing.max_guests = rand(1..5)
      listing.address_line1 = Faker::Address.street_address
      listing.city = Faker::Address.city
      listing.state = Faker::Address.state
      listing.country = "US"
      listing.status = :published
      listing.nightly_price = rand(1..100)
      listing.nightly_price = rand(1..20)
    end
  end
end
