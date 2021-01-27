class Response < ApplicationRecord
  belongs_to :request
  has_many :review
end
