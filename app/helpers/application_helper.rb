module ApplicationHelper

  def f_date(date)
    if "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day}"
      r_date = "Hoy"
      r_date = r_date + " a las " + date.strftime("%l:%M %P") if (date.hour != nil)
    elsif "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day - 1}"
      r_date = "Ayer"
      r_date = r_date + " a las " + date.strftime("%l:%M %P") if (date.hour != nil)
    elsif "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day + 1}"
      r_date = "Mañana"
      r_date = r_date + " a las " + date.strftime("%l:%M %P") if (date.hour != nil)
    else
      r_date = I18n.l(date, format: '%d de %B %Y a las %l:%M %P').capitalize
      # d = "#{date.year}#{date.month}#{date.day}".to_i
      # t = "#{Time.now.year}#{Time.now.month}#{Time.now.day}".to_i
      # if d > t
      #   r_date = "En #{t - d} días"
      # else
      #   r_date = "Hace #{d - t} días"
      # end
    end
  end

  def f_date_no_time(date)
    if "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day}"
      r_date = "Hoy a las " + date.strftime("%l:%M %P")
    elsif "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day - 1}"
      r_date = "Ayer"
    elsif "#{date.year}#{date.month}#{date.day}" == "#{Time.now.year}#{Time.now.month}#{Time.now.day + 1}"
      r_date = "Mañana a las " + date.strftime("%l:%M %P")
    else
      d = date.to_date
      t = Time.now.to_date
      if d > t
        r_date = "En #{(d - t).to_i} días"
      else
        r_date = "Hace #{(t - d).to_d} días"
      end
    end
  end

  def print_document(to, content, from)
    agreement = Agreement.find(params[:id])
    pdf = Prawn::Document.new(background: "private/membretada.png", background_scale: 0.36, right_margin: 20)
    pdf.font 'Helvetica'
    y= 600

    # Cabecera
    text = "Coordinación de Estudios de Posgrado" +
        "\n Chihuahua, Chih., a #{Date.today.day} de #{get_month_name(Date.today.month)} del #{Date.today.year}"
    pdf.text_box text, size: 11, at:[320,y], align: :right

    # Destinatario
    text = "to"
    pdf.text_box text, size: 11, at:[20,y-=50]
    # Presente
    pdf.formatted_text_box([:text => "Presente.-", :size => 12, :styles => [:bold] ], at:[20,y-=50])
    text = "Por este conducto me permito informar a Usted que el Comité de Estudios de Posgrado"
    pdf.text_box content, size: 11, at:[20,y-=50]
    # Contenido
    text = "#{candidate.name} se integrará #{(candidate.department.name.include? "Departamento") ? "al":"a" } #{candidate.department.name}, "+
        "realizando las siguientes funciones:"
    pdf.text_box text, size: 11, at:[20,y-=70]
    text = "#{candidate.function}"
    pdf.text_box text, size: 11, at:[20,y-=50]
    text = "A T E N T A M E N T E"
    pdf.text_box text, size: 11, at:[0,150], align: :center
    text = "Dr. José Alberto Duarte Möller \n Director Académico"
    pdf.text_box text, size: 11, at:[0,80], align: :center

    send_data pdf.render, filename: "contratacion#{candidate.name}.pdf", type: 'application/pdf', disposition: 'inline'
  end

end
