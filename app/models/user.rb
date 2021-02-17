class User < ApplicationRecord

  has_many :skills, foreign_key: :owner_id
  has_many :services, foreign_key: :owner_id
  has_many :requests, foreign_key: :requester_id
  has_many :own_requests, through: :services, source: :requests
  has_many :incoming_payments, class_name: 'Payment', foreign_key: :seller_id
  has_many :outgoing_payments, class_name: 'Payment', foreign_key: :payer_id
  has_many :outgoing_responses, through: :own_requests, source: :response
  has_many :incoming_responses, through: :requests, source: :response

  scope :by_skill_name, ->(name) { joins(:skills).where('skills.name like ?', "#{name}%") }


  has_secure_password

  enum role: { buyer: 0, seller: 1, admin: 2 }

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
