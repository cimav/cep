class Agreement < ApplicationRecord
  audited
  belongs_to :meeting
  has_many :agreement_file, dependent: :destroy
  has_many :responses, dependent: :destroy
  belongs_to :agreeable, polymorphic: true
  after_create :set_id_key

  after_update :generate_pdf

  OPEN = 1
  CLOSE = 2
  DELETED = 5

  NOT_SENT = 1
  SENT = 2


  STATUS = {OPEN=>'Abierto', CLOSE=>'Cerrado', DELETED =>'Eliminado'}

  before_create do
    self.status = OPEN
  end

  def get_status
    STATUS[self.status]
  end

  def set_id_key
    # Asignar número consecutivo
    last_consecutive = Agreement.where(meeting_id: self.meeting_id).maximum("consecutive")
    if last_consecutive.nil?
      consecutive = 1
    else
      consecutive = last_consecutive + 1
    end

    # Asignar folio
      id_key = "#{self.meeting.id_key}/A#{sprintf '%03d', consecutive}"

    self.consecutive = consecutive
    self.id_key = id_key
    self.save
  end

  # obtener texto de la decisión tomada
  def get_decision
    Response::FINAL_DECISIONS[self.decision]
  end

  def delete_agreeable
    self.agreeable.destroy unless self.agreeable_type.eql?'Scholarship'
  end

  def generate_pdf

    if self.status_changed? and self.status.equal? Agreement::CLOSE

      case self.agreeable_type
        when "GeneralIssue"
          pdf = GeneralIssuePdf.new(self)
          upload_auto_file(pdf, AgreementFile::AUTO,   "Oficio")

          pdf = VotingPdf.new(self)
          upload_auto_file(pdf, AgreementFile::VOTE,   "Votacion")

        when "PeerComitteeDesignation"
          pdf2 = PeerComitteeDesignationPdf.new(self, self.agreeable.peer2)
          upload_auto_file(pdf2, AgreementFile::AUTO, "Oficio")
      end

    end
  end


  def upload_auto_file(the_pdf, pdf_type, pdf_name)
    # PDFs autosubidos

    agreementFile = AgreementFile.new
    agreementFile.agreement = self
    agreementFile.pdf_data(the_pdf.render, pdf_type, pdf_name)
    agreementFile.name = agreementFile.file.filename

    agreementFile.save

  end

end
