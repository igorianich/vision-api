class Payment < ApplicationRecord
  belongs_to :request
  belongs_to :payer, class_name: 'User'
  belongs_to :seller, class_name: 'User'

  enum status: %i[waiting_for_payment paid rejected]

  validates :service_price, :net, :commission, numericality: { greater_than: 0 }
end
