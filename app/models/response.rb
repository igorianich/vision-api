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
    service.owner_id == respondent_id || errors.add(
      :respondent, "don't have request"
    )
    request.requester_id == requester_id || errors.add(
      :requester, "don't have request"
    )
  end
end
