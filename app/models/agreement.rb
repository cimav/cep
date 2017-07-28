class Agreement < ApplicationRecord
  belongs_to :meeting
  has_many :agreement_file
  belongs_to :agreeable, polymorphic: true

  SYNOD_DESINGATION = 1
  NEW_STUDENT =2

  TYPES = {SYNOD_DESINGATION => 'Asignación de sinodal', NEW_STUDENT => 'Nuevo ingreso'}

  def get_type
    TYPES[self.agreeable_type]
  end

end
