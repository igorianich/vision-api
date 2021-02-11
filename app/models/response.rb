class Response < ApplicationRecord
  belongs_to :request
  belongs_to :requester, class_name: 'User'
  belongs_to :respondent, class_name: 'User'
  has_many :reviews

  delegate :service, to: :request

  validates :file, :text, presence: true, length: { in: 5..100 }
  validate :rights_to_live_response

  private

  def rights_to_live_response
    request.service.owner_id == respondent_id ||
      errors.add(:respondent, "isn't recipient of the request ")

    request.requester_id == requester_id ||
      errors.add(:requester, "don't have this request")

    respondent.seller? ||
      errors.add(:respondent, 'must be seller')

    Response.where(request_id: request.id).exists? &&
      errors.add(:request, 'already has an answer')
  end
end
