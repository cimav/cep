class User < ApplicationRecord
  audited
  has_many :responses


  ADMIN = 1
  CEP = 2
  VIEWER = 3
  SUPER_USER = 1000
end
