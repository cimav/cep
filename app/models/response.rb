class Response < ApplicationRecord
  belongs_to :agreement
  belongs_to :user

  ACCEPTED = 1
  REJECTED = 2
  TO_COMMITTEE = 3
end
