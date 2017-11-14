class NewAdmission < ApplicationRecord
  belongs_to :applicant
  has_one :agreement, as: :agreeable, dependent: :destroy
end
