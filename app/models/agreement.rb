class Agreement < ApplicationRecord
  belongs_to :meeting
  has_many :agreement_file
  belongs_to :agreeable, polymorphic: true


  def get_type
    case self.agreeable_type
      when "NewAdmission"
        "Nuevo ingreso"
      when "SynodDesignation"
        "Designación de sinodales"
    end
  end

end
