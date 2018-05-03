class ScholarshipsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def document
    @scholarship = Scholarship.find(params[:id])

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
    text = "Por este conducto y de la manera más atenta solicito se sirva generar apoyo de Beca para: <b>#{@scholarship.person.full_name}</b>"
    pdf.move_down 20
    pdf.text text, inline_format: true
    # tabla
    pdf.font_size 8
    pdf.move_down 30
    if @scholarship.person_type == 'Internship'
    table_data = [['Actividad', 'Monto', 'Periodo', 'Responsable', 'Proyecto', 'No. solicitud'],
                  [@scholarship.person.internship_type.name, number_to_currency(@scholarship.amount, unit: "$", separator: ".", delimiter: ",", format: "%u%n"), "#{(I18n.l(@scholarship.start_date, format: '%B %Y')).capitalize} - #{(I18n.l(@scholarship.end_date, format: '%B %Y')).capitalize}", @scholarship.person.staff.full_name, (@scholarship.project_number rescue ''), (@scholarship.request_number rescue '')]]
    pdf.table table_data, :position => :center, header: @person = 'Internship'
    else
      table_data = [['Programa', 'Monto', 'Periodo', 'Director de tesis', 'Proyecto', 'No. solicitud'],
                    [@scholarship.person.program.name, number_to_currency(@scholarship.amount, unit: "$", separator: ".", delimiter: ",", format: "%u%n"), "#{(I18n.l(@scholarship.start_date, format: '%B %Y')).capitalize} - #{(I18n.l(@scholarship.end_date, format: '%B %Y')).capitalize}", @scholarship.person.supervisor.full_name, (@scholarship.project_number rescue ''), (@scholarship.request_number rescue '')]]
      pdf.table table_data, :position => :center, header: @person = 'Student'
    end
    true
    pdf.font_size 12
    text = "\n\n Sin más por el momento reciba un cordial saludo.."
    pdf.move_down 20
    pdf.text text, inline_format: true
    # nota sólo para practicantes
    if @scholarship.person_type == 'Internship'
      text = "“EL BECARIO DECLARA BAJO PROTESTA DE DECIR VERDAD QUE NO RECIBE APOYOS SIMILARES POR PARTE DE CONACYT”"
      pdf.move_down 40
      pdf.text text, align: :center, inline_format: true, size: 8
    end
    # atentamente
    text = "Atentamente,"
    pdf.move_down 70
    pdf.text text, align: :center
    # firma
    text = "<b>Lic. Emilio Pascual Domínguez Lechuga \n Coordinador de Estudios de Posgrado</b>"
    pdf.move_down 40
    pdf.text text, align: :center, inline_format: true

    send_data pdf.render, filename: "Solicitud de beca#{@scholarship.id}.pdf", type: 'application/pdf', disposition: 'inline'
  end

  def student_document(scholarship)
    render plain: 'Documento no disponible'
  end

  def update
    scholarship = Scholarship.find(params[:id])
    response = {}

    respond_to do |format|
      if is_admin?
        if scholarship.agreement.update(notes: params[:notes])

          response[:message] = 'Acuerdo actualizado'
          response[:redirect_url] = "agreements/#{scholarship.agreement.id}"

        else
          response[:message] = 'Error al actualizar acuerdo'
          response[:redirect_url] = "agreements/#{scholarship.agreement.id}"

        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end
      response[:errors] = scholarship.errors.full_messages
      response[:object] = scholarship
      format.json {render json: response}
    end
  end
end
