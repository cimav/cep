class Thesis < SaposModels
  belongs_to :student

  CONCLUDED   = 'C'
  IN_PROGRESS = 'P'
  INACTIVE    = 'I'

  STATUS = {CONCLUDED   => 'Concluida',
            IN_PROGRESS => 'En progreso',
            INACTIVE    => 'Inactiva'}

  def status_type
    STATUS[status]
  end
end
