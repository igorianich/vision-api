class Service < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :requests

  validates :name, presence: true, length: { in: 2..30 }
  validates :description, presence: true, length: { in: 5..100 }
  validates :price, numericality: { greater_than: 0 }
end
