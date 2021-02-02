class Request < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  belongs_to :service
  has_one :response
  has_one :payment

  enum status: %i[pending_answer completed rejected]

  validates :text, :file, presence: true, length: { in: 5..100 }
  validate :rights_to_live_request
  validate :good_balance

  def rights_to_live_request
    requester_role == 'buyer' or requester_role == 'admin' ||
      errors.add(:requester, 'must be buyer')
  end

  def requester_role
    requester.role
  end

  def good_balance
    requester.balance >= service.price || errors.add(
      :requester, "haven't enough balance"
    )
  end
end
