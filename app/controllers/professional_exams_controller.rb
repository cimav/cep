class ProfessionalExamsController < ApplicationController
  before_action :auth_required


  def create
    data = {}
    data = professional_exam_params
    data[:exam_date] = get_datetime(params)
    professional_exam = ProfessionalExam.new(data)
    response = {}

    respond_to do |format|
      if is_admin?
        if professional_exam.save

          agreement = professional_exam.build_agreement
          agreement.notes = params[:notes]
          agreement.meeting_id = params[:meeting_id]
          if professional_exam.save
            response[:message] = "Acuerdo creado"
            response[:redirect_url] = "agreements/#{agreement.id}"
          else
            response[:message] = "Error al registrar examen de grado"
            response[:redirect_url] = "meetings/#{agreement.meeting_id}/professional_exams/new"
          end

        else
          response[:message] = "Error al crear acuerdo"
          response[:errors] = professional_exam.errors.full_messages
          response[:redirect_url] = "meetings/#{params[:meeting_id]}/professional_exams/new"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = "meetings/#{agreement.meeting_id}/professional_exams/new"
      end

      format.json {render json: response}
    end


  end

  def update
    professional_exam = ProfessionalExam.find(params[:id])
    response = {}

    respond_to do |format|
      data = {}
      data = professional_exam_params
      data[:exam_date] = get_datetime(params)
      if is_admin?
        if professional_exam.update(data)
          professional_exam.agreement.update(notes:params[:notes])

          response[:message] = 'Acuerdo actualizado'
          response[:redirect_url] = "agreements/#{professional_exam.agreement.id}"

        else
          response[:message] = 'Error al actualizar acuerdo'
          response[:redirect_url] = "agreements/#{professional_exam.agreement.id}"

        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end
      response[:errors] = professional_exam.errors.full_messages
      response[:object] = professional_exam
      format.json {render json: response}
    end
  end

  def new
    @meeting_id = params[:meeting_id]
    @professional_exam = ProfessionalExam.new
    @students = Student.select("MAX(id) as id,first_name,last_name,program_id").where(:status=>[1,2,3,5,6]).group("first_name, last_name, program_id").order("first_name")
    render layout:false
  end


  def document
    professional_exam = ProfessionalExam.find(params[:id])
    if professional_exam.agreement.status.eql? Agreement::CLOSE
      to = "C. #{professional_exam.student.full_name}"
      content = "Por este conducto me permito informar a usted que el Comité de Estudios de Posgrado"
      if professional_exam.agreement.decision.eql? Response::ACCEPTED
        content += " ha aprobado su solicitud para presentar su examen de grado para el día <b>#{I18n.l(professional_exam.exam_date, format: '%d de %B del %Y a las %l:%M %P')}.</b>"
      elsif professional_exam.agreement.decision.eql? Response::REJECTED
        content += " ha rechazado su solicitud para presentar su examen de grado para el día <b>#{I18n.l(professional_exam.exam_date, format: '%d de %B del %Y a las %l:%M %P')}.</b>"
      elsif professional_exam.agreement.decision.eql? Response::TO_COMMITTEE
      end
      print_document(to,content,professional_exam.agreement)
    end
  end

  private

  def professional_exam_params
    params.require(:professional_exam).permit(:student_id, :exam_date, :synod1, :synod2,:synod3,:synod4,:synod5,:synod6,:synod7)
  end

  def get_datetime(params)
    date    = params[:date]
    time    = params[:time]
    return "#{date} #{time}"
  end


end
