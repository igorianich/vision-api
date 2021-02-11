class Request < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  belongs_to :service
  has_one :response, dependent: :destroy
  has_one :payment, dependent: :destroy

  enum status: { pending_answer: 0, completed: 1, rejected: 2 }

  validates :text, :file, presence: true, length: { in: 5..100 }
  validate :good_balance, on: :create
  validate :decline_error, if: -> { status == 'rejected' }

  private

  def good_balance
    requester.balance >= service.price || errors.add(
      :requester, "haven't enough balance"
    )
  end

  def decline_error
    Request.find(id).pending_answer? ||
      errors.add(:status, "can't be change")
  end
end
