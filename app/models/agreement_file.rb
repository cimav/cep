class AgreementFile < ApplicationRecord
  belongs_to :agreement
  mount_uploader :file, DocumentUploader

  after_destroy :delete_file

  def delete_file
    remove_file!
  end
end