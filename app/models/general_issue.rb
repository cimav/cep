class GeneralIssue < ApplicationRecord
  has_one :agreement, as: :agreeable, dependent: :destroy
end
