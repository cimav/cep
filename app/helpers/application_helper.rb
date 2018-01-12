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

  def print_document(to, content, agreement)
    pdf = Prawn::Document.new(background: "private/membretada.png", background_scale: 0.36, right_margin: 20)
    y= 600
    pdf.font_size 12

    if agreement.decision.eql? Response::TO_COMMITTEE
      text = "<b>Este acuerdo fue resuelto en reunión del comité</b>"
      pdf.fill_color "ff0000"
      pdf.text_box text, at:[0,300], align: :center, inline_format:true
      send_data pdf.render, filename: "acuerdo.pdf", type: 'application/pdf', disposition: 'inline'
    else
      # Cabecera
      text = "Coordinación de Estudios de Posgrado
           <b>#{agreement.id_key}</b>
            Chihuahua, Chih., a #{I18n.l(agreement.updated_at, format: '%d de %B del %Y')}"
      pdf.text_box text,size:11, at:[320,y], align: :right, inline_format:true

      # Destinatario
      text = to
      pdf.text_box text, at:[20,y-=60]
      # Presente
      pdf.text_box"<b>P r e s e n t e.-</b>", :size => 12, at:[20,y-=18], inline_format:true
      # contenido
      text = content + "\n\n Quedo a sus ordenes para cualquier duda al respecto."
      pdf.text_box text, at:[20,y-=50], inline_format:true
      # atentamente
      text = "Atentamente,"
      pdf.text_box text, at:[0,150], align: :center
      # firma
      text = "<b>Lic. Emilio Pascual Domínguez Lechuga \n Coordinador de Estudios de Posgrado</b>"
      pdf.text_box text, at:[0,80], align: :center, inline_format:true

      send_data pdf.render, filename: "acuerdo.pdf", type: 'application/pdf', disposition: 'inline'
    end


  end

end
