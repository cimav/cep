class ProfessionalExamsController < ApplicationController

  def create
    data = {}
    data = professional_exam_params
    data[:exam_date] = get_datetime(params)
    professional_exam = ProfessionalExam.new(data)
    response = {}

    respond_to do |format|
      if professional_exam.save

        agreement = professional_exam.build_agreement
        agreement.description = params[:description]
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
      if professional_exam.update(data)
        professional_exam.agreement.update(description:params[:description])

        response[:message] = 'Acuerdo actualizado'

      else
        response[:message] = 'Error al actualizar acuerdo'
      end
      response[:object] = professional_exam
      format.json {render json: response}
    end
  end

  def new
    @meeting_id = params[:meeting_id]
    @professional_exam = ProfessionalExam.new
    @students = Student.select("MAX(id) as id,first_name,last_name").where(:status=>[1,2,3,5,6]).group("first_name, last_name").order("first_name")
    render layout:false
  end



  private

  def professional_exam_params
    params.require(:professional_exam).permit(:student_id, :exam_date)
  end

  def get_datetime(params)
    date    = params[:date]
    time    = params[:time]
    return "#{date} #{time}"
  end


end
