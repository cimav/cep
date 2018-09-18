class User < ApplicationRecord
  audited
  has_many :responses
  before_create :set_status


  ADMIN = 1
  CEP = 2
  VIEWER = 3
  SUPER_USER = 1000

  ACTIVE = 1
  INACTIVE = 2
  DELETED = 99

  STATUS = {
      ACTIVE => 'Activo',
      INACTIVE => 'Inactivo'
  }

  def get_status
    STATUS[self.status]
  end

  def set_status
    self.status = ACTIVE
  end

end
