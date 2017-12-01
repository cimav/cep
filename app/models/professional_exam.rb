class ProfessionalExam < ApplicationRecord
  belongs_to :student
  has_one :agreement, as: :agreeable, dependent: :destroy

  #validates :exam_date, presence: true
end
