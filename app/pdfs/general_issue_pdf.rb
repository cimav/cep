class GeneralIssuePdf  < PrawnPdf

  def initialize(agreement)
    super(agreement)

  end

  def body_content # @overrided

    # encabezado
    if @agreement.agreeable.addressed_to.eql? GeneralIssue::TEACHER
      title = Staff.find(@agreement.agreeable.teacher).title rescue 'C.'
      full_name = Staff.find(@agreement.agreeable.teacher).full_name rescue 'A quien corresponda.'
      people = "#{title} #{full_name}"
    elsif @agreement.agreeable.addressed_to.eql? GeneralIssue::STUDENT
      title = 'C.'
      full_name = @agreement.agreeable.student.full_name rescue 'A quien corresponda.'
      people = "#{title} #{full_name}"
    else
      people = "A quien corresponda:"
    end

    cabecera(people, @agreement.agreeable_type)

    # CONTENIDO
    text = "Por este conducto me permito informar a Usted que el Comité de Estudios de Posgrado"
    text = "#{text} ha resuelto lo siguiente:"

    #if !@agreement.notes.blank?
    #  text = "#{text} \n\n#{@agreement.notes}"
    #end
    if !@agreement.agreeable.subject.blank?
      text = "#{text} \n\n#{@agreement.agreeable.resolution}"
    end

    text text, :align=>:justify,:inline_format=>true
    #  FIRMA
    atentamente = "\n\n\n\n<b>A t e n t a m e n t e\n\n\n\n#{@signer}</b>"
    text atentamente, :align=>:center,:valign=>:top,:inline_format=>true
    # FOOTER
    number_pages "Página <page> de <total>", :at=>[0,-23], :align=>:center, :size=>font_size-3,:inline_format=>true

  end

end