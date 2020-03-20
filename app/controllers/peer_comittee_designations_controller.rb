class PeerComitteeDesignationsController < ApplicationController

  before_action :auth_required

  def create
    peer_comittee_designation = PeerComitteeDesignation.new(peer_comittee_designation_params)
    response = {}

    respond_to do |format|

      if peer_comittee_designation.save
        agreement = peer_comittee_designation.build_agreement
        agreement.meeting_id = params[:meeting_id]
        if peer_comittee_designation.save
          response[:message] = 'Acuerdo creado'
          response[:redirect_url] = "agreements/#{agreement.id}"
        else
          response[:message] = 'Error al registrar designación de comité de pares'
          response[:redirect_url] = "meetings/#{agreement.meeting_id}/peer_comittee_designations/new"
        end

      else
        response[:message] = 'Error al crear acuerdo'
        response[:errors] = agreement.errors.full_messages[0]
        response[:redirect_url] = ""
      end
      response[:object] = peer_comittee_designation
      format.json {render json: response}
    end

  end

  def update
    peer_comittee_designation = PeerComitteeDesignation.find(params[:id])
    response = {}

    respond_to do |format|
      if is_admin?
        if peer_comittee_designation.update(peer_comittee_designation_params)
          peer_comittee_designation.agreement.update(notes:params[:notes])

          response[:message] = 'Acuerdo actualizado'
          response[:redirect_url] = "agreements/#{peer_comittee_designation.agreement.id}"
        else
          response[:message] = 'Error al actualizar acuerdo'
          #Se redirige al mismo acuerdo
          response[:redirect_url] = "meetings/#{peer_comittee_designation.agreement.meeting.id}/agreements/#{peer_comittee_designation.agreement.id}"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end

      response[:object] = peer_comittee_designation
      format.json {render json: response}
    end
  end


  def new
    @meeting_id = params[:meeting_id]
    @peer_comittee_designation = PeerComitteeDesignation.new
    @staffs = Staff.all.order(:first_name)
    @students = Student.select("MAX(id) as id,first_name,last_name,program_id").where(:status=>[1,2,3,5,6]).group("first_name, last_name, program_id").order("first_name")
    render layout:false
  end

  private

  def peer_comittee_designation_params
    params.require(:peer_comittee_designation).permit(:student_id, :peer1, :peer2)
  end

end
