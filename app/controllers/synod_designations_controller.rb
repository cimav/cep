class SynodDesignationsController < ApplicationController
  before_action :auth_required

  def create
    synod_designation = SynodDesignation.new(synod_designation_params)
    if synod_designation.save

      agreement = synod_designation.build_agreement
      agreement.description = params[:description]
      agreement.meeting_id = params[:meeting_id]
      if synod_designation.save
        flash[:success] = "Acuerdo creado"
      else
        flash[:error] = "Error al crear acuerdo"
        flash[:error] = agreement.errors.full_messages[0]
      end

    else
      flash[:error] = "Error al crear acuerdo"
      flash[:error] = agreement.errors.full_messages[0]

    end
    redirect_to synod_designation.agreement.meeting

  end

  def update
    synod_designation = SynodDesignation.find(params[:id])
    response = {}

    respond_to do |format|
    if synod_designation.update(synod_designation_params)
      synod_designation.agreement.update(description:params[:description])

      response[:message] = 'Acuerdo actualizado'
      response[:redirect_url] = "agreements/#{synod_designation.agreement.id}"
    else
      response[:message] = 'Error al actualizar acuerdo'
      #Se redirige al mismo acuerdo
      response[:redirect_url] = "meetings/#{synod_designation.agreement.meeting.id}/agreements/#{synod_designation.agreement.id}"
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
