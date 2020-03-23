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

      @r_root = Rails.root.to_s

      @signer = "Lic. Emilio Pascual Domínguez Lechuga\nCoordinador de Estudios de Posgrado"
      @sign   = "#{Rails.root.to_s}/private/firmas/firma1.png"
      @x_sign = 130
      @y_sign = 20
      @w_sign = 55

      @render_pdf = false
      @rectangles = false
      @nbsp = Prawn::Text::NBSP

      filename = "#{Rails.root.to_s}/private/prawn/membretada_conacyt_2020.png"
      Prawn::Document.new(:background => filename, :background_scale=>0.36, :margin=>[160,60,60,60] ) do |pdf|
        pdf.font_families.update(
            "Montserrat" => { :bold        => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Bold.ttf"),
                              :italic      => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Italic.ttf"),
                              :bold_italic => Rails.root.join("app/assets/fonts/montserrat/Montserrat-BoldItalic.ttf"),
                              :normal      => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Regular.ttf") })
        pdf.font "Montserrat"
        pdf.font_size 11
        ## CABECERA
        size = pdf.font_size
        s_date           = self.meeting.date
        last_change      = self.meeting.updated_at
        today            = Date.today
        @session_type    = self.meeting.get_type

        pdf.text "<b>Coordinación de estudios de Posgrado</b>\n", :inline_format=>true, :align=>:right, :size=>size
        pdf.text "<b>Oficio A#{self.consecutive}.#{last_change.month}<sup>#{self.meeting.consecutive}</sup>.#{last_change.year}</b>\n", :inline_format=>true, :align=>:right, :size=>size
        pdf.text "Chihuahua, Chih., a #{s_date.day} de #{get_month_name(s_date.month)} de #{s_date.year}", :inline_format=>true, :align=>:right, :size=>size


        if self.agreeable_type.eql? 'GeneralIssue'
          ############################### ASUNTOS GENERALES ###################################
          @render_pdf = true

          # Cabecera
          if self.agreeable.addressed_to.eql? GeneralIssue::TEACHER
            title = Staff.find(self.agreeable.teacher).title rescue 'C.'
            full_name = Staff.find(self.agreeable.teacher).full_name rescue 'A quien corresponda.'
            people = "#{title} #{full_name}"
          elsif self.agreeable.addressed_to.eql? GeneralIssue::STUDENT
            title = 'C.'
            full_name = self.agreeable.student.full_name rescue 'A quien corresponda.'
            people = "#{title} #{full_name}"
          else
            people = "A quien corresponda:"
          end
          cabecera(pdf,people,self.agreeable_type)

          # CONTENIDO
          text = "Por este conducto me permito informar a Usted que el Comité de Estudios de Posgrado"
          text = "#{text} ha resuelto lo siguiente:"

          if !self.notes.blank?
            text = "#{text} \n\n#{self.notes}"
          end
          if !self.agreeable.subject.blank?
            text = "#{text} \n\n#{self.agreeable.resolution}"
          end

          pdf.text text, :align=>:justify,:inline_format=>true
          #  FIRMA
          atentamente = "\n\n\n\n<b>A t e n t a m e n t e\n\n\n\n#{@signer}</b>"
          pdf.text atentamente, :align=>:center,:valign=>:top,:inline_format=>true
          # FOOTER
          pdf.number_pages "Página <page> de <total>", :at=>[0,-23], :align=>:center, :size=>size-3,:inline_format=>true


        elsif self.agreeable_type.eql? 'PeerComitteeDesignation'
          ############################### Designación de comité de Pares ###################################

          @render_pdf = true
	  pdf = PeerComitteeDesignationPdf.new(self, "#{Rails.root.to_s}/private/prawn/membretada_conacyt_2020.png")
        end

        if @render_pdf
          upload_auto_file(pdf)
        else
          render :text=>"Documento no disponible o no autorizado"
        end
      end#end Prawn

    end
  end

  def upload_auto_file(the_pdf)
    # PDFs autosubidos

    agreementFile = AgreementFile.new
    agreementFile.agreement = self
    agreementFile.pdf_data = the_pdf.render
    agreementFile.name = agreementFile.file.filename

	puts "ulpoad_file > #{agreementFile.name}"

    agreementFile.save

  end

  def cabecera(pdf, people, type)
    if type.eql? 4
      pdf.text "\n\n\n</b>#{people}</b>", :align=>:left,:inline_format=>true
      pdf.text "<b>Presente.</b>\n", :align=>:left, :character_spacing=>4,:inline_format=>true
    else
      pdf.text "\n\n\n\n</b>#{people}</b>", :align=>:left,:inline_format=>true
      pdf.text "<b>Presente.</b>\n\n", :align=>:left, :character_spacing=>4,:inline_format=>true
    end
  end

  def get_month_name(number)
    months = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]
    name = months[number - 1]
    return name
  end

end
