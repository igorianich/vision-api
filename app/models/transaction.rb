class Transaction < ApplicationRecord
  belongs_to :request

  enum status: [:waiting_for_payment, :paid, :rejected]
end
