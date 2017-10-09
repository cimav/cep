class Protocol < RemoteModels

  belongs_to :staff
  belongs_to :advance

  #has_many :answers

  CREATED   = 1
  SENT      = 2
  CANCELLED = 3

  STATUS = {
      CREATED   => 'Creado',
      SENT      => 'Enviado',
      CANCELLED => 'Cancelado'
  }

  def get_status
    STATUS[self.status]
  end
end