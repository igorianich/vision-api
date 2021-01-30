class Skill < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, length: { in: 2..30 }
  validates :description, presence: true, length: { in: 5..100 }
  validate :rights_to_live_skill

  private

  def rights_to_live_skill
    owner.role == 'seller' || errors.add(:owner, 'must be seller')
  end
end
