class TutorCommitteesController < ApplicationController
  before_action :auth_required

  def create
    tutor_committee = TutorCommittee.new(tutor_committee_params)
    response = {}

    respond_to do |format|

      if tutor_committee.save

        agreement = tutor_committee.build_agreement
        agreement.notes = params[:notes]
        agreement.meeting_id = params[:meeting_id]
        if tutor_committee.save
          response[:message] = 'Acuerdo creado'
          response[:redirect_url] = "agreements/#{agreement.id}"
        else
          response[:message] = 'Error al registrar comité tutoral'
          response[:redirect_url] = "meetings/#{agreement.meeting_id}/tutor_committees/new"
        end

      else
        response[:message] = 'Error al crear acuerdo'
        response[:errors] = agreement.errors.full_messages[0]
        response[:redirect_url] = ""
      end
      response[:object] = tutor_committee
      format.json {render json: response}
    end

  end

  def update
    tutor_committee = TutorCommittee.find(params[:id])
    response = {}

    respond_to do |format|
      if is_admin?
        if tutor_committee.update(tutor_committee_params)
          tutor_committee.agreement.update(notes:params[:notes])

          response[:message] = 'Acuerdo actualizado'
          response[:redirect_url] = "agreements/#{tutor_committee.agreement.id}"
        else
          response[:message] = 'Error al actualizar acuerdo'
          #Se redirige al mismo acuerdo
          response[:redirect_url] = "meetings/#{tutor_committee.agreement.meeting.id}/agreements/#{tutor_committee.agreement.id}"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end

      response[:object] = tutor_committee
      format.json {render json: response}
    end
  end

  def new
    @meeting_id= params[:meeting_id]
    @tutor_committee = TutorCommittee.new
    @staffs = Staff.all.order(:first_name)
    @students = Student.select("MAX(id) as id,first_name,last_name").where(:status=>[1,2,3,5,6]).group("first_name, last_name").order("first_name")
    render layout:false
  end



  private

  def tutor_committee_params
    params.require(:tutor_committee).permit(:student_id, :tutor1, :tutor2, :tutor3, :tutor4, :tutor5)
  end


end
