class Student < SaposModels
  belongs_to :program
  belongs_to :supervisor, :foreign_key => "supervisor", :class_name => "Staff"
  belongs_to :campus
  has_many :term_students
  has_one :thesis
  has_many :advance
  has_many :professional_exams
  has_many :synod_designations
  has_many :tutor_committees
  has_many :thesis_directors

  has_many :student_files

  has_many :scholarships, as: :person


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

  def get_average
    counter = 0
    counter_grade = 0
    sum = 0
    avg = 0
    self.term_students.each do |te|
      te.term_course_student.where(:status => TermCourseStudent::ACTIVE).each do |tcs|
        counter += 1
        if !(tcs.grade.nil?)
          if !(tcs.grade<70)
            counter_grade += 1
            sum = sum + tcs.grade
          end
        end
      end
    end

    if counter > 0
      avg = (sum / (counter_grade * 1.0)).round(2) if counter_grade > 0
    end
    return avg.to_s
  end

end