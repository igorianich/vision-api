class Response < ApplicationRecord
  belongs_to :request
  belongs_to :requester, class_name: 'User'
  belongs_to :respondent, class_name: 'User'
  has_many :reviews

  validates :file, :text, presence: true, length: { in: 5..100 }
end
