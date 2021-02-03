class User < ApplicationRecord
  has_many :skills, foreign_key: :owner_id
  has_many :services, foreign_key: :owner_id
  has_many :requests, foreign_key: :requester_id
  has_many :own_requests, through: :services, source: :requests
  has_many :reviews, foreign_key: :reviewer_id
  has_many :incoming_payments, class_name: 'Payment', foreign_key: :seller_id
  has_many :outgoing_payments, class_name: 'Payment', foreign_key: :payer_id
  has_many :outgoing_responses, class_name: 'Response', foreign_key: :respondent_id
  has_many :incoming_responses, class_name: 'Response', foreign_key: :requester_id

  has_secure_password

  enum role: %i[buyer seller admin]

  validates :first_name, :last_name, presence: true, length: { in: 2..30 }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :description, presence: true, length: { in: 10..130 }
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :age, numericality: {
    only_integer: true, greater_than: 17, less_than: 111
  }

  def add_balance(arg)
    update(balance: balance + arg)
  end

  def subtract_balance(arg)
    update(balance: balance - arg)
  end

end
