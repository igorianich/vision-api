class Payment < ApplicationRecord
  belongs_to :request
  belongs_to :payer, class_name: 'User'
  belongs_to :seller, class_name: 'User'

  enum status: %i[waiting_for_payment paid rejected]

  validates :service_price, :net, :commission, numericality: { greater_than: 0 }
  validate :rights_to_live_payment

  private

  def rights_to_live_payment
    request.requester_id == payer_id || errors.add(:payer, "don't have request")
    request.service.owner_id == seller_id || errors.add(
      :seller, "don't have request"
    )
    service_price > net || errors.add(:net, "can't be greater than service_price")
    net > commission || errors.add(:net, "can't be less than commission")
  end
end
