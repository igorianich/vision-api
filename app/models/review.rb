class Review < ApplicationRecord
  belongs_to :response
  belongs_to :reviewer, class_name: 'User'

  validates :rate, inclusion: 1..5
  validates :file, :text, presence: true, length: { in: 5..100 }
  validate :rights_to_live_review

  private

  def rights_to_live_review
    Review.where(response: response).exists? &&
      errors.add(:response, 'already has a review')
  end
end
