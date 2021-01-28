class Request < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  belongs_to :service
  has_one :response
  has_one :payment

  enum status: %i[pending_answer completed rejected]

  validates :text, :file, presence: true, length: { in: 5..100 }
end
