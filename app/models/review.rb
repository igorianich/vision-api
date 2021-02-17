class Review < ApplicationRecord
  belongs_to :response
  has_one :request, through: :response, source: :request
  has_one :reviewer, through: :request, source: :requester

  validates :rate, inclusion: 1..5
  validates :file, :text, presence: true, length: { in: 5..100 }
  validate :rights_to_live_review, on: :create

  private

  def rights_to_live_review
    Review.where(response: response).exists? &&
      errors.add(:response, 'already has a review')
  end
end
