class ScholarshipsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  skip_before_action :auth_required, only: [:public_document]

  def public_document
    document
  end

  def document
    @scholarship = Scholarship.find(params[:id])

    pdf = Prawn::Document.new(background: "private/membretada.png", background_scale: 0.36, right_margin: 20)
    pdf.font_size 12
    pdf.font_families.update(
        "Montserrat" => { :bold        => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Bold.ttf"),
                          :italic      => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Italic.ttf"),
                          :bold_italic => Rails.root.join("app/assets/fonts/montserrat/Montserrat-BoldItalic.ttf"),
                          :normal      => Rails.root.join("app/assets/fonts/montserrat/Montserrat-Regular.ttf") })
    pdf.font "Montserrat"
    pdf.font_size 11
    # Cabecera
    text = "Chihuahua, Chih., a #{I18n.l(Date.today, format: '%d de %B del %Y')}"
    pdf.move_down 100
    pdf.text text, size: 11, align: :right, inline_format: true

    # Destinatario
    text = "C.P. Justo Martínez Carrazco \nEncargado de Despacho de la\nDirección de Administración y Finanzas \nCIMAV"
    pdf.move_down 10
    pdf.text text
    # Presente
    pdf.move_down 10
    pdf.text "<b>P r e s e n t e.-</b>", :size => 12, inline_format: true
    # contenido
    text = "Por este conducto le comento que el Comité de Estudios de Posgrado con fecha de este oficio autorizó el pago de la beca:"
    pdf.move_down 20
    pdf.text text, inline_format: true
    # tabla
    pdf.font_size 10
    pdf.move_down 30
    if @scholarship.person_type == 'Internship'
    table_data = [['Actividad', 'Nombre del Becario', 'Monto', 'Periodo', 'Responsable', 'Proyecto', 'No. solicitud'],
                  [@scholarship.person.internship_type.name, @scholarship.person.full_name,number_to_currency(@scholarship.amount, unit: "$", separator: ".", delimiter: ",", format: "%u%n"), "#{(I18n.l(@scholarship.start_date, format: '%B %Y')).capitalize} - #{(I18n.l(@scholarship.end_date, format: '%B %Y')).capitalize}", @scholarship.person.staff.full_name, (@scholarship.project_number rescue ''), (@scholarship.request_number rescue '')]]
    pdf.table table_data, :position => :center, header: @person = 'Internship'
    else
      pdf.font_size 9
      table_data = [['Programa', 'Nombre del Becario', 'Monto', 'Periodo', 'Director de tesis', 'Proyecto', 'No. solicitud'],
                    [@scholarship.person.program.name, @scholarship.person.full_name, number_to_currency(@scholarship.amount, unit: "$", separator: ".", delimiter: ",", format: "%u%n"), "#{(I18n.l(@scholarship.start_date, format: '%B %Y')).capitalize} - #{(I18n.l(@scholarship.end_date, format: '%B %Y')).capitalize}", @scholarship.person.supervisor.full_name, (@scholarship.project_number rescue ''), (@scholarship.request_number rescue '')]]
      pdf.table table_data, :position => :center, header: @person = 'Student'
    end
    true
    pdf.font_size 10
    text = "\n\n Por lo anterior le solicito de la manera más atenta se sirva generar el apoyo correspondiente"
    pdf.move_down 20
    pdf.text text, inline_format: true

    text = "\n\n Sin más por el momento reciba un cordial saludo"
    pdf.move_down 20
    pdf.text text, inline_format: true

    # atentamente
    text = "Atentamente,"
    pdf.move_down 70
    pdf.text text, align: :center
    # firma
    text = "<b>Lic. Emilio Pascual Domínguez Lechuga \n Coordinador de Estudios de Posgrado</b>"
    pdf.move_down 40
    pdf.text text, align: :center, inline_format: true

    # nota sólo para practicantes
    if @scholarship.person_type == 'Internship'
      text = "“EL BECARIO DECLARA BAJO PROTESTA DE DECIR VERDAD QUE NO RECIBE APOYOS SIMILARES POR PARTE DE CONACYT”"
      pdf.move_down 40
      pdf.text text, align: :center, inline_format: true, size: 8
    end

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
