class Course < SaposModels
  belongs_to :program
  #belongs_to :studies_plan
  #belongs_to :studies_plan_area

  has_many :term_courses
end