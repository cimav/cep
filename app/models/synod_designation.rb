class SynodDesignation < ApplicationRecord
  belongs_to :student
  belongs_to :agreement
  validates :student, :presence => true

end
