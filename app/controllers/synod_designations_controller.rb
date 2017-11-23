class SynodDesignationsController < ApplicationController
  before_action :auth_required

  def create
    synod_designation = SynodDesignation.new(synod_designation_params)
    response = {}

    respond_to do |format|

      if synod_designation.save

        agreement = synod_designation.build_agreement
        agreement.notes = params[:notes]
        agreement.meeting_id = params[:meeting_id]
        if synod_designation.save
          response[:message] = 'Acuerdo creado'
          response[:redirect_url] = "agreements/#{agreement.id}"
        else
          response[:message] = 'Error al registrar designación de sinodales'
          response[:redirect_url] = "meetings/#{agreement.meeting_id}/synod_designations/new"
        end

      else
        response[:message] = 'Error al crear acuerdo'
        response[:errors] = agreement.errors.full_messages[0]
        response[:redirect_url] = ""
      end
      response[:object] = synod_designation
      format.json {render json: response}
    end

  end

  def update
    synod_designation = SynodDesignation.find(params[:id])
    response = {}

    respond_to do |format|
      if is_admin?
        if synod_designation.update(synod_designation_params)
          synod_designation.agreement.update(notes:params[:notes])

          response[:message] = 'Acuerdo actualizado'
          response[:redirect_url] = "agreements/#{synod_designation.agreement.id}"
        else
          response[:message] = 'Error al actualizar acuerdo'
          #Se redirige al mismo acuerdo
          response[:redirect_url] = "meetings/#{synod_designation.agreement.meeting.id}/agreements/#{synod_designation.agreement.id}"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end

    response[:object] = synod_designation
    format.json {render json: response}
    end
  end

def new
  @meeting_id= params[:meeting_id]
  @synod_designation = SynodDesignation.new
  @staffs = Staff.all.order(:first_name)
  @students = Student.select("MAX(id) as id,first_name,last_name").where(:status=>[1,2,3,5,6]).group("first_name, last_name").order("first_name")
  render layout:false
end



  private

  def synod_designation_params
    params.require(:synod_designation).permit(:student_id, :synodal1, :synodal2, :synodal3, :synodal4, :synodal5)
  end



end
