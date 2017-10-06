class TermStudent < RemoteModels
  has_many :term_course_student
  belongs_to :student

  ACTIVE   = 1
  PENDING  = 2
  INACTIVE = 3
  PENROLLMENT   = 6

  STATUS = {ACTIVE   => 'Activo',
            PENDING  => 'Con pendientes',
            INACTIVE => 'Baja',
            PENROLLMENT => 'Pre-inscrito'}

  def status_type
    STATUS[status]
  end
end