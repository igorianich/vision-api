class User < ApplicationRecord
  has_many :skills, foreign_key: :owner_id
  has_many :services, foreign_key: :owner_id
  has_many :requests, foreign_key: :requester_id
  has_many :reviews, foreign_key: :reviewer_id
  has_many :incoming_payments, class_name: 'Payment', foreign_key: :seller_id
  has_many :outgoing_payments, class_name: 'Payment', foreign_key: :payer_id
  has_many :outgoing_responses, class_name: 'Response', foreign_key: :respondent_id
  has_many :incoming_responses, class_name: 'Response', foreign_key: :requester_id

  has_secure_password

  enum role: [:buyer, :seller, :admin]
end
