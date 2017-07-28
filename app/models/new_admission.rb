class NewAdmission < ApplicationRecord
  belongs_to :student
  has_one :agreement, as: :agreeable
end
