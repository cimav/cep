class Agreement < ApplicationRecord
  belongs_to :meeting
  has_many :agreement_file
end
