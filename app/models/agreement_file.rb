class AgreementFile < ApplicationRecord
  belongs_to :agreement
  mount_uploader :file, DocumentUploader

  after_destroy :delete_file

  def delete_file
    remove_file!
  end

  AUTO = 1
  FILE_TYPE = {AUTO=>'AutoGenerada'}

  def pdf_data=(data)
    self.file = CarrierStringIO.new(data)
    self.file_type = AUTO
  end

end

class CarrierStringIO < StringIO
  # https://stackoverflow.com/questions/54042417/uploading-pdf-with-prawn-and-carrierwave-without-saving-the-file-on-disk
  # define class that extends IO with methods that are required by carrierwave

  def original_filename
   "OrginalFilenameTempo.pdf"
  end

  def content_type
    "application/pdf"
  end
end
