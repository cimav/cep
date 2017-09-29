class Agreement < ApplicationRecord
  belongs_to :meeting
  has_many :agreement_file
  has_many :responses, dependent: :destroy
  belongs_to :agreeable, polymorphic: true
  after_create :set_id_key


  ACCEPTED = 1
  REJECTED = 2
  TO_COMMITTEE = 3


  OPEN = 1
  CLOSE = 2
  DELETED = 5


  STATUS = {OPEN=>'Abierto', CLOSE=>'Cerrado', TO_COMMITTEE=> 'Enviado a comité'}
  DECISIONS = {ACCEPTED =>'Aceptado', REJECTED => 'Rechazado', TO_COMMITTEE => 'Resolver en comité'}

  before_create do
    self.status = OPEN
  end

  def get_status
    STATUS[self.status]
  end

  def get_decision
    DECISIONS[self.decision]
  end

  def get_type
    case self.agreeable_type
      when "NewAdmission"
        "Nuevo ingreso"
      when "SynodDesignation"
        "Designación de sinodales"
      when "ProfessionalExam"
        "Examen de grado"
    end
  end

  def set_id_key
    # Asignar número consecutivo
    last_consecutive = Agreement.where(meeting_id: self.meeting_id).maximum("consecutive")
    if last_consecutive.nil?
      consecutive = 1
    else
      consecutive = last_consecutive + 1
    end

    # Asignar folio
      id_key = "#{self.meeting.id_key}/A#{sprintf '%03d', consecutive}"

    self.consecutive = consecutive
    self.id_key = id_key
    self.save
  end

  def delete_agreeable
    self.agreeable.destroy
  end
end
