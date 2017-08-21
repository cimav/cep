class User < ApplicationRecord
  belongs_to :staff
  has_many :responses

  ADMIN = 1
  CEP = 2
  SUPER_USER = 1000
end
