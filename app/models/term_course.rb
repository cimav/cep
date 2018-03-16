class TermCourse < SaposModels
  belongs_to :term
  belongs_to :course
  belongs_to :staff

  #has_many :term_course_schedules
  has_many :term_course_students


  ASSIGNED   = 1
  UNASSIGNED = 2
  DELETED = 3
end