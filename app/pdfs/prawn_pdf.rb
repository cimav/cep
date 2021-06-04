class PrawnPdf < Prawn::Document

  def initialize(agreement)
    super(:background => "#{Rails.root.to_s}/private/prawn/membretada.png", :background_scale=>0.36, :margin=>[160,60,60,60])

    @agreement = agreement

    @r_root = Rails.root.to_s

    @signer = "Lic. Emilio Pascual Domínguez Lechuga\nCoordinador de Estudios de Posgrado"
    @sign   = "#{Rails.root.to_s}/private/firmas/firma1.png"
    @x_sign = 130
    @y_sign = 20
    @w_sign = 55

    @render_pdf = false
    @rectangles = false
    @nbsp = Prawn::Text::NBSP

    font_families.update(
        "Montserrat" => { :bold        => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Bold.ttf"),
                          :italic      => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Italic.ttf"),
                          :bold_italic => Rails.root.join("app/assets/fonts/montserrat/Montserrat-BoldItalic.ttf"),
                          :normal      => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Regular.ttf") })
    font "Montserrat"
    font_size 11

    @session_type    = @agreement.meeting.get_type

    body_content

  end

  def body_content

  end

  def cabecera(people, type)
    s_date           = @agreement.meeting.date
    last_change      = @agreement.meeting.updated_at
    today            = Date.today

    text "<b>Coordinación de estudios de Posgrado</b>\n", :inline_format=>true, :align=>:right, :size=>font_size
    text "<b>Oficio A#{@agreement.consecutive}.#{last_change.month}<sup>#{@agreement.meeting.consecutive}</sup>.#{last_change.year}</b>\n", :inline_format=>true, :align=>:right, :size=>font_size
    text "Chihuahua, Chih., a #{s_date.day} de #{get_month_name(s_date.month)} de #{s_date.year}", :inline_format=>true, :align=>:right, :size=>font_size

    if type.eql? 4 # @agreement.agreeable_type
      text "\n\n\n</b>#{people}</b>", :align=>:left,:inline_format=>true
      text "<b>Presente.</b>\n", :align=>:left, :character_spacing=>4,:inline_format=>true
    else
      text "\n\n\n\n</b>#{people}</b>", :align=>:left,:inline_format=>true
      text "<b>Presente.</b>\n\n", :align=>:left, :character_spacing=>4,:inline_format=>true
    end
  end

  def get_month_name(number)
    months = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]
    name = months[number - 1]
    return name
  end

end