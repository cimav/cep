class Staff < SaposModels
  has_many :teacher_evaluations
  belongs_to :institution
  belongs_to :area
  has_many :term_courses

  ACTIVE    = 0
  INACTIVE  = 1

  STATUS = {ACTIVE    => 'Activo',
            INACTIVE  => 'Inactivo'}



  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end