class Agreement < ApplicationRecord
  belongs_to :meeting
  has_many :agreement_file
  belongs_to :agreeable, polymorphic: true


  OPEN = 1
  CLOSE = 2
  TO_COMMITTEE = 3


  STATUS = {OPEN=>'Abierto', CLOSE=>'Cerrado', TO_COMMITTEE=> 'Enviado a comité'}

  before_create do
    self.status = OPEN
  end

  def get_type
    case self.agreeable_type
      when "NewAdmission"
        "Nuevo ingreso"
      when "SynodDesignation"
        "Designación de sinodales"
      when "ProfessionalExam"
        "Examen profesional"
    end
  end
end
