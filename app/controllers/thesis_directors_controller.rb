class ThesisDirectorsController < ApplicationController
  before_action :auth_required

  def create
    thesis_director = ThesisDirector.new(thesis_director_params)
    response = {}

    respond_to do |format|

      if thesis_director.save

        agreement = thesis_director.build_agreement
        agreement.notes = params[:notes]
        agreement.meeting_id = params[:meeting_id]
        if thesis_director.save
          response[:message] = 'Acuerdo creado'
          response[:redirect_url] = "agreements/#{agreement.id}"
        else
          response[:message] = 'Error al registrar director de tesis'
          response[:redirect_url] = "meetings/#{agreement.meeting_id}/thesis_directors/new"
        end

      else
        response[:message] = 'Error al crear acuerdo'
        response[:errors] = agreement.errors.full_messages[0]
        response[:redirect_url] = ""
      end
      response[:object] = thesis_director
      format.json {render json: response}
    end

  end

  def update
    thesis_director = ThesisDirector.find(params[:id])
    response = {}

    respond_to do |format|
      if is_admin?
        if thesis_director.update(thesis_director_params)
          thesis_director.agreement.update(notes:params[:notes])

          response[:message] = 'Acuerdo actualizado'
          response[:redirect_url] = "agreements/#{thesis_director.agreement.id}"
        else
          response[:message] = 'Error al actualizar acuerdo'
          #Se redirige al mismo acuerdo
          response[:redirect_url] = "meetings/#{thesis_director.agreement.meeting.id}/agreements/#{thesis_director.agreement.id}"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end

      response[:object] = thesis_director
      format.json {render json: response}
    end
  end

  def new
    @meeting_id= params[:meeting_id]
    @thesis_director = ThesisDirector.new
    @staffs = Staff.all.order(:first_name)
    @students = Student.select("MAX(id) as id,first_name,last_name").where(:status=>[1,2,3,5,6]).group("first_name, last_name").order("first_name")
    render layout:false
  end



  private

  def thesis_director_params
    params.require(:thesis_director).permit(:student_id, :director)
  end


end
