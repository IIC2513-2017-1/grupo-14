# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Participation.destroy_all
Winner.destroy_all
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
   balance: 10000
  )
end

x = User.create(
  name: 'Juan',
  mail: 'hola@12.cl',
  password: '123456',
  role: 'admin',
  balance: 10000
)
u = User.create(
  name: 'Juan2',
  mail: 'juanfra.campos2@gmail.com',
  password: '123456',
  role: 'regular',
  balance: 10000
)
m = User.create(
  name: 'Juan4',
  mail: 'jfcampos1@uc.cl',
  password: '123456',
  role: 'regular',
  balance: 10000
)

u = User.create(
  name: 'Rorro',
  mail: 'hola3@12.cl',
  password: 'asdasd',
  role: 'regular',
  balance: 10000
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
    user_id: user_ids.sample,
    private: false
  )
end

v = Bet.create(
    name: 'Hoollaa',
    description: Faker::StarWars.quote,
    deadline: Date.tomorrow,
    max_participants: Faker::Number.digit,
    kind: Faker::StarWars.wookie_sentence,
    min_bet: 10,
    max_bet: 5000,
    user_id: user_ids.sample,
    private: false
  )


bet_ids = Bet.pluck(:id)
bet_ids.each do |bet_id|
  3.times do
    Choice.create(
    	value: Faker::Book.title,
      bet_id: bet_id
    )
  end
end

10.times do
  Choice.create(
  	value: Faker::Book.title,
    bet_id: bet_ids.sample
  )
end

n = Choice.create(
    value: Faker::Book.title,
    bet_id: v.id
  )
j = Choice.create(
    value: Faker::Book.title,
    bet_id: v.id
  )

Participation.create(
  amount: 500,
  user_id: u.id,
  bet_id: v.id,
  choice_id: n.id
  )
Participation.create(
  amount: 500,
  user_id: m.id,
  bet_id: v.id,
  choice_id: j.id
  )
