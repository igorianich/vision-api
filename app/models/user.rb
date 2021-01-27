class User < ApplicationRecord
  has_many :skills
  has_many :services
  has_many :requests
  has_many :reviews
end
