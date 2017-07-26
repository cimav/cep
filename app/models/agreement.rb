class Agreement < ApplicationRecord
  belongs_to :meeting
  has_many :agreement_file
  has_one :synod_designation
  validates :agreement_type, :presence => true
  accepts_nested_attributes_for :synod_designation, :allow_destroy => true

  ASIG_SINODAL = 1
  NUEVO_INGRESO =2

  TYPES = {ASIG_SINODAL => 'Asignación de sinodal', NUEVO_INGRESO => 'Nuevo ingreso'}

  def get_type
    TYPES[self.agreement_type]
  end

end
