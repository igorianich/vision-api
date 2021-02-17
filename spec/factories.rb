FactoryBot.define do

  factory :user do
    first_name { 'Joe' }
    last_name  { 'Blow' }
    description  { 'description' }
    email { "#{first_name}.#{last_name}@gmail.com".downcase }
    age { 22 }
    password { '123456' }
    balance { 500 }
    role { :buyer }
  end

  factory :skill do
    name { 'Dancing' }
    association :owner, factory: :user, role: :seller
    description { 'description' }
  end

  factory :service do
    name { 'Rate your dancing' }
    association :owner, factory: :user, role: :seller
    description { 'description' }
    price { 40 }
  end

  factory :request do
    service
    association :requester, factory: :user
    text { 'texttexttext' }
    file { 'filefilefile' }
    status { 0 }
  end

  factory :payment do
    request
    payer { request.requester }
    seller { request.service.owner }
    service_price { 40 }
    net { 36 }
    commission { 4 }
  end

  factory :response do
    request
    text { 'texttexttext' }
    file { 'filefilefile' }
  end

  factory :review do
    response
    rate { 5 }
    text { 'texttexttext' }
    file { 'filefilefile' }
  end


end
