class TermCourseStudent < SaposModels
  belongs_to :term_course
  belongs_to :term_student

  ACTIVE        = 1
  INACTIVE      = 2
  PENROLLMENT   = 6

  STATUS = {ACTIVE   => 'Activo',
            INACTIVE => 'Baja',
            PENROLLMENT => 'Pre-inscrito'}

  def status_type
    STATUS[status]
  end
end