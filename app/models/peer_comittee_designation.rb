class PeerComitteeDesignation < ApplicationRecord
  belongs_to :student
  has_one :agreement, as: :agreeable, dependent: :destroy

  validates :peer1, presence: true
  validates :peer2, presence: true

end