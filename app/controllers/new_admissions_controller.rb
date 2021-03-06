class NewAdmissionsController < ApplicationController
  before_action :auth_required

  def create
    new_admission = NewAdmission.new(new_admission_params)
    response = {}

    respond_to do |format|
      if is_admin?
        if new_admission.save

          agreement = new_admission.build_agreement
          agreement.notes = params[:notes]
          agreement.meeting_id = params[:meeting_id]
          if new_admission.save
            response[:message] = "Acuerdo creado"
            response[:redirect_url] = "agreements/#{agreement.id}"
          else
            response[:message] = "Error al registrar nueva admisión"
            response[:redirect_url] = "meetings/#{agreement.meeting_id}/new_admissions/new"
          end

        else
          response[:message] = "Error al crear acuerdo"
          response[:errors] = new_admission.errors.full_messages
          response[:redirect_url] = "meetings/#{params[:meeting_id]}/new_admissions/new"

        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end
      format.json {render json: response}
    end
  end

  def update
    new_admission = NewAdmission.find(params[:id])
    response = {}

    respond_to do |format|
      if is_admin?
        if new_admission.update(new_admission_params)
          new_admission.agreement.update(notes:params[:notes])

          response[:message] = 'Acuerdo actualizado'
          response[:redirect_url] = "agreements/#{new_admission.agreement.id}"

        else
          response[:message] = 'Error al actualizar acuerdo'
          response[:redirect_url] = "agreements/#{new_admission.agreement.id}"
        end
      else
        response[:message] = 'Sólo el administrador puede realizar esta acción'
        response[:redirect_url] = ""
      end

      response[:object] = new_admission
      format.json {render json: response}
    end
  end

  def new
    @meeting_id = params[:meeting_id]
    @new_admission = NewAdmission.new
    @applicants = Applicant.where.not(status:[Applicant::DELETED, Applicant::DESISTS])
    @students = Student.select("MAX(id) as id,first_name,last_name").where(:status=>[1,2,3,5,6]).group("first_name, last_name").order("first_name")
    render layout:false
  end

  def document
    new_admission = NewAdmission.find(params[:id])
    if new_admission.agreement.status.eql? Agreement::CLOSE
      to = "C. #{new_admission.applicant.full_name}"
      content = "Por este conducto me permito informar a usted que el Comité de Estudios de Posgrado"
      if new_admission.agreement.decision.eql? Response::PROGRAM_ACCEPTED
        content += " ha aprobado su solicitud para entrar en el programa de <b>#{new_admission.applicant.program.name}.</b>"
      elsif new_admission.agreement.decision.eql? Response::PROPAEDEUTIC
        content += " ha aprobado su solicitud para entrar al <b>Curso Propedéutico en #{new_admission.applicant.program.name}.</b>"
      end
      print_document(to,content,new_admission.agreement)
    end
  end

  private

  def new_admission_params
    params.require(:new_admission).permit(:applicant_id)
  end


end
