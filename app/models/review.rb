class Review < ApplicationRecord
  belongs_to :response
  belongs_to :reviewer, class_name: 'User'

  validates :rate, inclusion: 1..5
  validates :file, :text, presence: true, length: { in: 5..100 }

  private

  def rights_to_live_review
    # smth_exists = Response.where(
    #   id: response_id, requester_id: reviewer_id
    # ).exists?

    return if response.requester_id == reviewer_id

    errors.add(
      :reviewer, "don't have request"
    )
  end
end
