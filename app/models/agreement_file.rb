class AgreementFile < ApplicationRecord
  belongs_to :agreement
  mount_uploader :file, DocumentUploader

  after_destroy :delete_file

  def delete_file
    remove_file!
  end

  AUTO = 1
  VOTE = 2
  FILE_TYPE = {AUTO=>'Oficio', VOTE=>'Votacion'}

  def pdf_data(data, pdf_type, pdf_name)
    self.file_type = pdf_type
    self.file = CarrierStringIO.new(data, pdf_name)
  end

end

class CarrierStringIO < StringIO
  # https://stackoverflow.com/questions/54042417/uploading-pdf-with-prawn-and-carrierwave-without-saving-the-file-on-disk
  # define class that extends IO with methods that are required by carrierwave

  def initialize(data, pdf_name)
    super(data)
    @pdf_name = pdf_name
  end

  def original_filename
    "#{@pdf_name}.pdf"
  end

  def content_type
    "application/pdf"
  end
end
