class SynodDesignation < ApplicationRecord
  belongs_to :student
  has_one :agreement, as: :agreeable, dependent: :destroy

  validates :synodal1, presence: true
  validates :synodal2, presence: true
  validates :synodal3, presence: true
end
