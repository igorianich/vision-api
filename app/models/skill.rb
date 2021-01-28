class Skill < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  validates :name, :description, presence: true, length: { in: 2..30 }
end
