class Response < ApplicationRecord
  belongs_to :request
  belongs_to :requester
  belongs_to :respondent
  has_many :review
end
