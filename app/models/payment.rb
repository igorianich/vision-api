class Payment < ApplicationRecord
  belongs_to :request
  belongs_to :payer, class_name: 'User'
  belongs_to :seller, class_name: 'User'

  enum status: %i[waiting_for_payment paid rejected]

  validates :service_price, :net, :commission, numericality: { greater_than: 0 }
  validate :rights_to_live_payment
  validate :good_balance, :pay_error, if: -> { status == 'paid' }

  def pay
    update(status: 'paid') && payer.subtract_balance(net) && seller.add_balance(net)
  end

  private

  def rights_to_live_payment
    request.requester.id == payer_id || errors.add(:payer, "don't have request")
    request.service.owner_id == seller_id ||
      errors.add(:seller, "don't have request")

    service_price > net || errors.add(:net, "can't be greater than service_price")
    net > commission || errors.add(:net, "can't be less than commission")
  end

  def pay_error
    Payment.find_by(id: id).status == 'waiting_for_payment' ||
      errors.add(:status, "can't be change")

    payer.role != 'seller' ||
      errors.add(:payer, "can't be a seller")
  end

  def good_balance
    payer.balance >= service_price || errors.add(
      :payer, "haven't enough balance"
    )
  end
end
