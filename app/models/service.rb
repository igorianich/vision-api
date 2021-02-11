# frozen_string_literal: true

class Service < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :requests

  validates :name, presence: true, length: { in: 2..30 }
  validates :description, presence: true, length: { in: 5..100 }
  validates :price, numericality: { greater_than: 0 }
  validate :rights_to_live_service

  scope :by_owner, ->(owner_id) { where(owner_id: owner_id) }
  scope :by_name, ->(name) { where('name like ?', "#{name}%") }
  scope :min_price, ->(price) { where(arel_table[:price].gt(price)) }
  scope :max_price, ->(price) { where(arel_table[:price].lt(price)) }

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
