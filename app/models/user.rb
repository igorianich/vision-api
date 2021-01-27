class User < ApplicationRecord
  has_many :skills
  has_many :services
  has_many :requests
  has_many :reviews

  has_secure_password

  enum role: [:buyer, :seller, :admin]
end
