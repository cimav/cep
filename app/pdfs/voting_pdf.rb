class VotingPdf < PrawnPdf

  def initialize(agreement)
    super(agreement)
  end

  def body_content # @overrided

    s_date = @agreement.meeting.date
    text "Chihuahua, Chih., a #{s_date.day} de #{get_month_name(s_date.month)} de #{s_date.year}", :inline_format=>true, :align=>:right, :size=>font_size

    text "\n<b>Asunto:</b>:\n", :align=>:justify,:inline_format=>true
    subject = @agreement.agreeable.subject.blank? ? "Sin asunto.\n\n" : "#{@agreement.agreeable.subject}\n\n"
    text subject, :align=>:justify,:inline_format=>true

    text "<b>Votación:</b>:\n", :align=>:justify,:inline_format=>true
    data = []
    data << [{:content => "<b>Miembro</b>", :align => :center}, {:content => "<b>Voto</b>", :align => :center}, {:content => "<b>Comentario</b>", :align => :center}]
    @agreement.responses.each do |r|
      data << [r.user.name, r.answer, r.comment]
    end
    tabla = make_table(data, :width => 500, :cell_style => {:size => 9, :padding => 2, :inline_format => true, :border_width => 1},
                           :position => :center, :column_widths => [205, 80, 215])
    tabla.draw

    text "\n\n<b>Resolución:</b>:", :align=>:justify,:inline_format=>true
    resolution = @agreement.agreeable.resolution.blank? ? "\nSin resolución.\n\n" : "\n#{@agreement.agreeable.resolution}\n\n"
    text resolution, :align=>:justify,:inline_format=>true

    # FOOTER
    number_pages "Página <page> de <total>", :at=>[0,-23], :align=>:center, :size=>font_size,:inline_format=>true

  end

end