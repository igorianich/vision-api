class Payment < ApplicationRecord
  belongs_to :request
  belongs_to :payer, class_name: 'User'
  belongs_to :seller, class_name: 'User'
  # has_one :seller, class_name: 'User', through: :requests, source: :owner

  enum status: [:waiting_for_payment, :paid, :rejected]
end
