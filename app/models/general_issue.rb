class GeneralIssue < ApplicationRecord
  belongs_to :student
  has_one :agreement, as: :agreeable, dependent: :destroy

  TO_WHOM_CONCERN = 0
  TEACHER = 1
  STUDENT = 2
  ADDRESSED_TO_TYPE = {TO_WHOM_CONCERN=> 'A quien corresponda', TEACHER => 'Docente', STUDENT => 'Estudiante'}

end
