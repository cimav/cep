class Student < RemoteModels
  belongs_to :program
  belongs_to :campus

  def full_name
    "#{self.first_name} #{self.last_name}"
  end


  DELETED      = 0
  ACTIVE       = 1
  GRADUATED    = 2
  INACTIVE     = 3
  UNREGISTERED = 4
  FINISH       = 5
  PENROLLMENT  = 6

  STATUS = {
      ACTIVE        => 'Activo',
      FINISH        => 'Egresado no graduado',
      GRADUATED     => 'Graduado',
      INACTIVE      => 'Baja temporal',
      UNREGISTERED  => 'Baja definitiva',
      PENROLLMENT   => 'Pre-inscrito'
  }

  def get_status
    STATUS[status]
  end

end