# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create(
  [
    {
      email: 'qwerty@gmail.com', password: '123456', first_name: 'Roman',
      last_name: 'Mazuh', age: 21, description: 'Some description', role: 0,
      balance: 500
    },
    {
      email: 'asdfgh@gmail.com', password: '123456', first_name: 'Petro',
      last_name: 'Kazuh', age: 34, description: 'Some description', role: 1,
      balance: 500
    },
    {
      email: 'zxcvbn@gmail.com', password: '123456', first_name: 'Vitalik',
      last_name: 'Corok', age: 24, description: 'Some description', role: 2,
      balance: 500
    }
  ]
)

skills = Skill.create(
  [
    { owner_id: 2, name: 'Dancing', description: 'Some description' },
    { owner_id: 2, name: 'Singing', description: 'Some description' },
    { owner_id: 2, name: 'Focuse', description: 'Some description' }
  ]
)

services = Service.create(
  [
    {
      owner_id: 2, name: 'Evaluate your singing', price: 40  ,
      description: 'Some description'
    },
    {
      owner_id: 2, name: 'Evaluate your dancing', price: 50,
      description: 'Some description'
    },
    {
      owner_id: 2, name: 'Evaluate your focuse', price: 10,
      description: 'Some description'
    }
  ]
)

requests = Request.create(
  [
    { requester_id: 1, service_id: 1, text: 'Some text', file: 'Some file', status: 1 },
    { requester_id: 1, service_id: 2, text: 'Some text', file: 'Some file', status: 1 },
    { requester_id: 3, service_id: 1, text: 'Some text', file: 'Some file', status: 1  },
    { requester_id: 3, service_id: 3, text: 'Some text', file: 'Some file', status: 1  }
  ]
)

responses = Response.create(
  [
    { request_id: 1, respondent_id: 2, requester_id: 1, text: 'Some text',
      file: 'Some file'  },
    { request_id: 3, respondent_id: 2, requester_id: 3, text: 'Some text',
      file: 'Some file'  },
    { request_id: 4, respondent_id: 2, requester_id: 3, text: 'Some text',
      file: 'Some file'  }
  ]
)

reviews = Review.create(
  [
    { response_id: 1, reviewer_id: 1, text: 'Some text', file: 'Some file', rate: 4 },
    { response_id: 2, reviewer_id: 3, text: 'Some text', file: 'Some file', rate: 5 }
  ]
)

payments = Payment.create(
  [
    { request_id: 1, payer_id: 1, seller_id: 2, service_price: 40, net: 35,
      commission: 5, status: 0 },
    { request_id: 2, payer_id: 0, seller_id: 2, service_price: 50, net: 40,
      commission: 10, status: 0 },
    { request_id: 3, payer_id: 3, seller_id: 2, service_price: 40, net: 35,
      commission: 5, status: 0 },
    { request_id: 4, payer_id: 3, seller_id: 2, service_price: 30, net: 25,
      commission: 5, status: 0 }
  ]
)
