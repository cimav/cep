class AgreementFile < ApplicationRecord
  belongs_to :agreement
  mount_uploader :name, DocumentUploader

  after_destroy :delete_file

  def delete_file
    remove_name!
  end
end