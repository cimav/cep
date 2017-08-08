class SynodDesignation < ApplicationRecord
  belongs_to :student
  has_one :agreement, as: :agreeable, dependent: :destroy
end
