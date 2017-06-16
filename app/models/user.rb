class User < ApplicationRecord
  belongs_to :staff
  has_many :response
end
