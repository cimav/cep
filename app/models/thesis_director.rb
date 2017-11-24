class ThesisDirector < ApplicationRecord
  belongs_to :student
  has_one :agreement, as: :agreeable, dependent: :destroy

  validates :director, presence: true
end
