class Scholarship < ApplicationRecord
  self.abstract_class = true
  establish_connection BECAS_DB
  self.table_name = 'scholarships'

  belongs_to :person, polymorphic: true
  belongs_to :scholarship_type


  has_one :agreement, as: :agreeable, dependent: :destroy
end
