class PeerComitteeDesignationPdf < Prawn::Document

  def initialize(agreement)
    super(:background => "#{Rails.root.to_s}/private/prawn/membretada_conacyt_2020.png", :background_scale=>0.36, :margin=>[160,60,60,60])

    font_families.update(
        "Montserrat" => { :bold        => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Bold.ttf"),
                          :italic      => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Italic.ttf"),
                          :bold_italic => Rails.root.join("app/assets/fonts/montserrat/Montserrat-BoldItalic.ttf"),
                          :normal      => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Regular.ttf") })
    font "Montserrat"
    font_size 11
    ## CABECERA
    size = font_size
    s_date           = agreement.meeting.date
    last_change      = agreement.meeting.updated_at
    today            = Date.today
    @session_type    = agreement.meeting.get_type

    text "<b>Coordinación de estudios de Posgrado</b>\n", :inline_format=>true, :align=>:right, :size=>size
    text "<b>Oficio A#{agreement.consecutive}.#{last_change.month}<sup>#{agreement.meeting.consecutive}</sup>.#{last_change.year}</b>\n", :inline_format=>true, :align=>:right, :size=>size
    text "Chihuahua, Chih., a #{s_date.day} de #{get_month_name(s_date.month)} de #{s_date.year}", :inline_format=>true, :align=>:right, :size=>size

    @render_pdf  = true

    p1_title = Staff.find(agreement.agreeable.peer1).title rescue 'C.'
    p1_full_name = Staff.find(agreement.agreeable.peer1).full_name rescue 'A quien corresponda.'
    student_full_name = agreement.agreeable.student.full_name rescue 'C.'
    student_program = agreement.agreeable.student.program.name rescue 'A quien corresponda.'
    supervisor_full_name = agreement.agreeable.supervisor.title rescue 'C.'
    supervisor_title = agreement.agreeable.supervisor.full_name rescue 'A quien corresponda.'

    people = "#{p1_title} #{p1_full_name}"
    cabecera(people,agreement.agreeable_type)


    # CONTENIDO
    text "Por este conducto me permito informar a Usted que el Comité de Estudios de Posgrado lo ha nombrado integrante del Comité de Pares de #{student_full_name} adscrito al programa de #{student_program}.\n\n Quedo a sus ordenes para cualquier duda al respecto.", :align=>:justify,:inline_format=>true
    #  FIRMA
    @signer = "Lic. Emilio Pascual Domínguez Lechuga\nCoordinador de Estudios de Posgrado"
    atentamente = "\n\n\n\n<b>A t e n t a m e n t e\n\n\n\n#{@signer}</b>"
    text atentamente, :align=>:center, :inline_format=>true
    # CCP
    x = 0
    w = 350
    h = 25
    texto = "c.c.p. #{supervisor_title} #{supervisor_full_name} - Director de Tesis.\n #{student_full_name} - Estudiante"
    text_box texto, :at=>[x,bounds.bottom+50], :align=>:left, :valign=>:top, :width=>w, :height=>h, :inline_format=>true, :size=>size-2
    # FOOTER
    number_pages "Página <page> de <total>", :at=>[0,-23], :align=>:center, :size=>size-3,:inline_format=>true

  end

  def cabecera(people, type)
    if type.eql? 4
      self.text "\n\n\n</b>#{people}</b>", :align=>:left,:inline_format=>true
      self.text "<b>Presente.</b>\n", :align=>:left, :character_spacing=>4,:inline_format=>true
    else
      self.text "\n\n\n\n</b>#{people}</b>", :align=>:left,:inline_format=>true
      self.text "<b>Presente.</b>\n\n", :align=>:left, :character_spacing=>4,:inline_format=>true
    end
  end

  def get_month_name(number)
    months = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]
    name = months[number - 1]
    return name
  end

end