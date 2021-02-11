# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :request
  belongs_to :payer, class_name: 'User'
  belongs_to :seller, class_name: 'User'

  enum status: { reserved: 0, paid: 1, rejected: 2 }

  validates :service_price, :net, :commission, numericality: { greater_than: 0 }
  validate :rights_to_live_payment
  validate :good_balance, :pay_error, if: -> { status == 'paid' }

  def reserve
    update(status: :reserved) && payer.subtract_balance(service_price)
  end

  def pay
    update(status: :paid) && seller.add_balance(net)
  end

  def reject
    update(status: :rejected) && payer.add_balance(service_price)
  end

  private

  def rights_to_live_payment
    service_price > net || errors.add(:net, "can't be greater than service_price")
    net > commission || errors.add(:net, "can't be less than commission")
  end

  def pay_error
    Payment.find(id).reserved? ||
      errors.add(:status, "can't be change")
  end

  def good_balance
    payer.balance >= service_price || errors.add(
      :payer, "haven't enough balance"
    )
  end
end
