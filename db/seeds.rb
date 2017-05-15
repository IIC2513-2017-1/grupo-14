# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Participation.destroy_all
Choice.destroy_all
Bet.destroy_all
User.destroy_all


# Create Users
5.times do
 User.create(
   name: Faker::Name.unique.first_name,
   mail: Faker::Internet.unique.email,
   password: Faker::Internet.password,
   role: 'regular',
  )
end

u = User.create(
  name: 'Juan',
  mail: 'hola@12.cl',
  password: '123456',
  role: 'admin'
)

# Create bets
user_ids = User.pluck(:id)
30.times do
  Bet.create(
  	name: Faker::Name.title,
  	description: Faker::StarWars.quote,
  	deadline: Faker::Date.forward(30),
  	max_participants: Faker::Number.digit,
  	kind: Faker::StarWars.wookie_sentence,
  	min_bet: Faker::Number.digit,
  	max_bet: Faker::Number.number(4),
    user_id: user_ids.sample
  )
end


bet_ids = Bet.pluck(:id)
10.times do
  Choice.create(
  	value: Faker::Book.title,
    bet_id: bet_ids.sample
  )
end