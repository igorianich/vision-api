class Review < ApplicationRecord
  belongs_to :response
  belongs_to :reviewer, class_name: 'User'

  validates :rate, inclusion: 1..5
  validates :file, :text, presence: true, length: { in: 5..100 }
end
