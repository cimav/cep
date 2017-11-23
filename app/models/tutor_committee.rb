class TutorCommittee < ApplicationRecord
  belongs_to :student
  has_one :agreement, as: :agreeable, dependent: :destroy

  validates :tutor1, presence: true
  validates :tutor2, presence: true
  validates :tutor3, presence: true
end
