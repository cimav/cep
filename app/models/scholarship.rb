class Scholarship < ApplicationRecord
  audited
  self.abstract_class = true
  establish_connection BECAS_DB
  self.table_name = 'scholarships'

  belongs_to :person, polymorphic: true
  belongs_to :scholarship_type

  has_one :agreement, as: :agreeable, dependent: :destroy


  REQUESTED =   1
  APPROVED =   2
  ACTIVE =   3
  INACTIVE =   4
  REJECTED =   5
  TO_COMMITTEE =   6
  DELETED =   99
end
