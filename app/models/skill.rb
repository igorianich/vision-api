class Skill < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, length: { in: 2..30 }
  validates :description, presence: true, length: { in: 5..100 }
  validate :rights_to_live_skill

  private

  def owner_role
    owner.role
  end

  def rights_to_live_skill
    owner_role == 'seller' or owner_role == 'admin' || errors.add(:owner, 'must be seller')
  end
end
