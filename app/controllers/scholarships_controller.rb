class ScholarshipsController < ApplicationController
  include ActionView::Helpers::NumberHelper


  def document
    @scholarship = Scholarship.find(params[:id])
    if @scholarship.person_type == 'Internship'
      internship_document(@scholarship)
    else
      student_document(@scholarship)
    end
  end

  def internship_document(scholarship)
    
    pdf = Prawn::Document.new(background: "private/membretada2018.png", background_scale: 0.36, right_margin: 20)
    pdf.font_size 12
    # Cabecera
    text = "Coordinación de Estudios de Posgrado
         <b>FOLIO---</b>
          Chihuahua, Chih., a #{I18n.l(Date.today, format: '%d de %B del %Y')}"
    pdf.move_down 100
    pdf.text text, size: 11, align: :right, inline_format: true

    # Destinatario
    text = "Lic. Nathanael Martínez Coronel \n Director de Administración y Finanzas \n CIMAV"
    pdf.move_down 10
    pdf.text text
    # Presente
    pdf.move_down 10
    pdf.text "<b>P r e s e n t e.-</b>", :size => 12, inline_format: true
    # contenido
    text = "Por este conducto y de la manera más atenta solicito se sirva generar apoyo de Beca para: <b>#{scholarship.person.full_name}</b>"
    pdf.move_down 20
    pdf.text text, inline_format: true
    # tabla
    pdf.font_size 10
    pdf.move_down 30
    table_data = [['Actividad', 'Monto', 'Periodo', 'Responsable', 'Proyecto', 'No. solicitud'],
                  [scholarship.person.internship_type.name, number_to_currency(scholarship.amount, unit: "$", separator: ".", delimiter: ",", format: "%u%n"), "#{(I18n.l(scholarship.start_date, format: '%B %Y')).capitalize} - #{(I18n.l(scholarship.end_date, format: '%B %Y')).capitalize}", scholarship.person.staff.full_name, (scholarship.project_number rescue ''), (scholarship.request_number rescue '')]]
    pdf.table table_data, :position => :center, header: @person = 'Internship'
    true
    pdf.font_size 12
    text = "\n\n Sin más por el momento reciba un cordial saludo.."
    pdf.move_down 20
    pdf.text text, inline_format: true
    # nota
    text = "“EL BECARIO DECLARA BAJO PROTESTA DE DECIR VERDAD QUE NO RECIBE APOYOS SIMILARES POR PARTE DE CONACYT”"
    pdf.move_down 40
    pdf.text text, align: :center, inline_format: true, size: 8
    # atentamente
    text = "Atentamente,"
    pdf.move_down 70
    pdf.text text, align: :center
    # firma
    text = "<b>Lic. Emilio Pascual Domínguez Lechuga \n Coordinador de Estudios de Posgrado</b>"
    pdf.move_down 40
    pdf.text text, align: :center, inline_format: true

    send_data pdf.render, filename: "Solicitud de beca#{scholarship.id}.pdf", type: 'application/pdf', disposition: 'inline'
  end
  
  def student_document(scholarship)
    render plain:'Documento no disponible'
  end

end
