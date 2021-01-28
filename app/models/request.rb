class Request < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  belongs_to :service
  has_one :response
  has_one :payment

  enum status: [:pending_answer, :completed, :rejected]

end
