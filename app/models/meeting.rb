class Meeting < ApplicationRecord
  has_many :agreement

  ORDINARY = 1
  EXTRAORDINARY = 2

  MEETING_TYPES = {ORDINARY => 'Ordinaria', EXTRAORDINARY => 'Extraordinaria'}

  OPENED = 1
  CLOSED = 2

  MEETING_STATUS = {OPENED => 'Abierta', CLOSED => 'Cerrada'}

  def get_type
    MEETING_TYPES[self.meeting_type]
  end

  def get_status
    MEETING_STATUS[self.status]
  end

  def get_datetime_split(dateORTime)
    date = self.date
    if dateOrTime == 1
      date.split(" ")[0].to_date
    end
  end
end
