class TermStudent < RemoteModels
  has_many :term_course_student
  belongs_to :student
end