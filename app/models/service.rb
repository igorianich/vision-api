# frozen_string_literal: true

class Service < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :requests

  validates :name, presence: true, length: { in: 2..30 }
  validates :description, presence: true, length: { in: 5..100 }
  validates :price, numericality: { greater_than: 0 }
  validate :rights_to_live_service

  def net
    price * 0.9
  end

  def commission
    price * 0.1
  end

  private

  def rights_to_live_service
    owner.role == 'seller' || errors.add(:owner, 'must be seller')
  end
end
