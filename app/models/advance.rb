class Advance < RemoteModels
  belongs_to :student
  has_many :protocols

  ADVANCE  = 1
  PROTOCOL = 2
  SEMINAR  = 3

  TYPES = {
      ADVANCE   => 'Avance programático',
      PROTOCOL  => 'Evaluación de protocolo',
      SEMINAR   => 'Seminario Departamental',
  }

  def get_type
    TYPES[self.advance_type]
  end

end