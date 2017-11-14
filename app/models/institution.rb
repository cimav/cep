class Institution < RemoteModels
  has_many :staffs
  has_many :applicants

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


  def full_name
    "#{name} (#{short_name})" rescue ''
  end

end