class PeerComitteeDesignationPdf < PrawnPdf

  def initialize(agreement, peer)
    @peer = peer
    super(agreement)
  end

  def body_content

    p1_title = Staff.find(@peer).title rescue 'C.'
    p1_full_name = Staff.find(@peer).full_name rescue 'A quien corresponda.'
    student_full_name = @agreement.agreeable.student.full_name rescue 'C.'
    student_program = @agreement.agreeable.student.program.name rescue 'A quien corresponda.'
    supervisor_full_name = @agreement.agreeable.supervisor.title rescue 'C.'
    supervisor_title = @agreement.agreeable.supervisor.full_name rescue 'A quien corresponda.'
    people = "#{p1_title} #{p1_full_name}"
    cabecera(people,@agreement.agreeable_type)

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
    text_box texto, :at=>[x,bounds.bottom+50], :align=>:left, :valign=>:top, :width=>w, :height=>h, :inline_format=>true, :size=>font_size-2
    # FOOTER
    number_pages "Página <page> de <total>", :at=>[0,-23], :align=>:center, :size=>font_size-3,:inline_format=>true

  end

  def concat(pdf_file)
    pdf_temp_nb_pages = pdf_file.page_count
    (1..pdf_temp_nb_pages).each do |i|
      self.start_new_page(:template => pdf_file, :template_page => i)
    end
  end

end
