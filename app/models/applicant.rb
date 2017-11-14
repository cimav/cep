class Applicant < RemoteModels
  belongs_to :program
  belongs_to :campus
  belongs_to :institution, foreign_key: :previous_institution
  has_many :new_admissions


  REGISTERED    = 1
  REJECTED      = 2
  ACCEPTED      = 3
  DELETED       = 4
  ACCEPTED_PROP = 5
  DESISTS       = 6
  REQUEST_PASS  = 7
  REQUEST = 8

  STATUS = {
      REGISTERED    => 'En Proceso',
      REJECTED      => 'No Aceptado',
      ACCEPTED      => 'Aceptado',
      ACCEPTED_PROP => 'Aceptado a propedeutico',
      DELETED       => 'Borrado',
      DESISTS       => 'Desiste',
      REQUEST_PASS  => 'Solicitud de password',
      REQUEST       => 'Solicitud',
  }

  def full_name
    "#{self.first_name} #{self.primary_last_name} #{self.second_last_name}" rescue ''
  end

  def get_status
    STATUS[self.status]
  end
end