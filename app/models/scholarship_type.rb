class ScholarshipType < ApplicationRecord
  self.abstract_class = true
  establish_connection BECAS_DB
  self.table_name = 'scholarship_types'

  has_many :scholarships

  CONACYT = 1
  FISCAL = 2
  OWN_RESOURCES = 3

  # status
  ACTIVE = 1
  DELETED = 99

  CATEGORIES = {CONACYT=>'CONACYT', FISCAL=>'Fiscales', OWN_RESOURCES=>'Recursos propios'}

  def get_category
    CATEGORIES[self.category]
  end
end
